#include "FirebaseUploader.h"

#include <QFile>
#include <QFileInfo>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QDebug>
#include <QDateTime>
#include <QUrl>
#include <QUrlQuery>
#include <fstream>
#include <vector>
#include <map>

#pragma pack(push, 1)
struct ULogMessageHeader {
    uint16_t msg_size;
    uint8_t msg_type;
};
#pragma pack(pop)

const QString FIREBASE_PROJECT_ID      = "turtlebot3-waiter";
const QString FIREBASE_STORAGE_BUCKET  = "turtlebot3-waiter.firebasestorage.app";
const QString FIREBASE_API_KEY         = "AIzaSyDJiq1NF1cESp82H3vBZO2kv6RnElqTX4c";

FirebaseUploader::FirebaseUploader(const QString& logFilePath, QObject *parent)
    : QObject(parent), _logFilePath(logFilePath), _newCount(1)
{
    _networkManager = new QNetworkAccessManager(this);
}

void FirebaseUploader::startUpload()
{
    if (parseUlogFile())
        fetchLatestCount();
    else
    {
        qWarning() << "Could not parse ULog file, aborting upload:" << _logFilePath;
        this->deleteLater();
    }
}

void FirebaseUploader::fetchLatestCount()
{
    qDebug() << "Fetching latest count from collection:" << _droneTypeString;

    QJsonObject structuredQuery;
    QJsonObject from;
    from["collectionId"] = _droneTypeString;
    structuredQuery["from"] = QJsonArray{from};
    
    QJsonObject orderBy;
    orderBy["field"] = QJsonObject{{"fieldPath", "count"}};
    orderBy["direction"] = "DESCENDING";
    structuredQuery["orderBy"] = QJsonArray{orderBy};
    
    structuredQuery["limit"] = 1;
    
    QJsonObject requestBody;
    requestBody["structuredQuery"] = structuredQuery;

    QString url_string = QString("https://firestore.googleapis.com/v1/projects/%1/databases/(default)/documents:runQuery?key=%2")
                      .arg(FIREBASE_PROJECT_ID, FIREBASE_API_KEY);

    QNetworkRequest request{QUrl{url_string}};
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply* reply = _networkManager->post(request, QJsonDocument(requestBody).toJson());
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onCountFetchFinished(reply);
    });
}

void FirebaseUploader::onCountFetchFinished(QNetworkReply* reply)
{
    int latestCount = 0;
    if (reply->error() == QNetworkReply::NoError)
    {
        QByteArray responseData = reply->readAll();
        QJsonDocument jsonResponse = QJsonDocument::fromJson(responseData);
        
        if (jsonResponse.isArray())
        {
            QJsonArray documents = jsonResponse.array();
            qDebug() << "DOCUMENT MESSAGE:" << documents.at(0);
            if (!documents.isEmpty())
            {
                QJsonValue firstDocValue = documents.at(0);
                if (firstDocValue.isObject() && firstDocValue.toObject().contains("document"))
                {
                    QJsonObject docObject = firstDocValue.toObject()["document"].toObject();
                    QJsonValue fieldsValue = docObject.value("fields");
                    if (fieldsValue.isObject())
                    {
                        QJsonObject fields = fieldsValue.toObject();
                        QJsonValue countValue = fields.value("count");
                        if (countValue.isObject())
                        {
                            QJsonValue val = countValue.toObject().value("doubleValue");
                            if (val.isDouble())
                                latestCount = static_cast<int>(val.toDouble());
                        }
                    }
                }
            }
        }
    }
    else
    {
        qWarning() << "Could not fetch latest count. Error:" << reply->errorString();
        qWarning() << "Response:" << reply->readAll();
    }
    
    _newCount = latestCount + 1;
    reply->deleteLater();

    qDebug() << "Latest count is:" << latestCount << ". New count will be:" << _newCount;
    uploadLogToStorage();
}

bool FirebaseUploader::parseUlogFile()
{
    try {
        qDebug() << "--- Starting ULog Parse ---";
        qDebug() << "Parsing file:" << _logFilePath;
        std::ifstream fs{_logFilePath.toStdWString(), std::ios::in | std::ios::binary};
        if (!fs.is_open())
        {
            qWarning() << "Failed to open file:" << _logFilePath;
            return false;
        }

        fs.seekg(16, std::ios::beg);

        std::map<uint16_t, QString> msg_id_to_name;
        std::map<QString, QString> format_map;
        std::map<QString, std::vector<QJsonObject>> data_map;
        
        while (fs)
        {
            ULogMessageHeader msg_header;
            fs.read(reinterpret_cast<char*>(&msg_header), sizeof(msg_header));
            if (!fs) break;

            std::vector<char> payload(msg_header.msg_size);
            fs.read(payload.data(), msg_header.msg_size);
            if (!fs) break;
            
            switch (msg_header.msg_type)
            {
                case 'I':
                {
                    uint8_t key_len = payload[0];
                    char key_str[256] = {};
                    memcpy(key_str, payload.data() + 1, key_len);
                    char value_str[256] = {};
                    memcpy(value_str, payload.data() + 1 + key_len, payload.size() - 1 - key_len);
                    if (QString(key_str) == "ver_hw")
                        _flightMetadata["hardware"] = QString(value_str);
                    break;
                }
                case 'F':
                { 
                    char format_str[2048] = {};
                    memcpy(format_str, payload.data(), payload.size());
                    QString q_format_str(format_str);
                    QString name = q_format_str.section(':', 0, 0);
                    QString fields = q_format_str.section(':', 1);
                    format_map[name] = fields;
                    break;
                }
                case 'A':
                { 
                    uint16_t msg_id = *reinterpret_cast<uint16_t*>(payload.data() + 1);
                    char name_str[256] = {};
                    memcpy(name_str, payload.data() + 3, payload.size() - 3);
                    msg_id_to_name[msg_id] = QString(name_str);
                    break;
                }
                case 'D':
                { 
                    uint16_t msg_id = *reinterpret_cast<uint16_t*>(payload.data());
                    if (msg_id_to_name.count(msg_id))
                    {
                        QString msg_name = msg_id_to_name[msg_id];
                        if (msg_name == "vehicle_metadata")
                        {
                            uint32_t production_date_val = *(reinterpret_cast<uint32_t*>(payload.data() + 10));
                            uint32_t drone_id_val = *(reinterpret_cast<uint32_t*>(payload.data() + 14));
                            uint8_t power_mode_val = *(reinterpret_cast<uint8_t*>(payload.data() + 18));
                            
                            qDebug() << "--- Found vehicle_metadata ---";
                            qDebug() << "Raw drone_id:" << drone_id_val;
                            qDebug() << "Raw production_date:" << production_date_val;
                            qDebug() << "Raw power_mode:" << power_mode_val;

                            QJsonObject drone_type;
                            drone_type["class"] = (drone_id_val / 100000 == 0) ? "Light" : "Heavy";
                            drone_type["weight_kg"] = static_cast<int>((drone_id_val / 100) % 1000);
                            drone_type["propellers"] = static_cast<int>(drone_id_val % 100);
                            _flightMetadata["drone_type"] = drone_type;
                            _flightMetadata["power_mode"] = (power_mode_val == 0) ? "Pure Electricity" : "Unknown";
                            _flightMetadata["production_date"] = QDateTime::fromString(QString::number(production_date_val), "yyyyMMdd").toString("yyyy-MM-dd");
                            
                            _droneTypeString = QString("CT-HV-%1D-%2")
                                                   .arg(drone_type["weight_kg"].toInt())
                                                   .arg(drone_type["propellers"].toInt());
                        }
                        else if (msg_name == "vehicle_gps_position")
                        {
                            QJsonObject gps_point;
                            gps_point["latitude"] = (*(reinterpret_cast<const int32_t*>(payload.data() + 18))) / 1.0e8;
                            gps_point["longitude"] = (*(reinterpret_cast<const int32_t*>(payload.data() + 22))) / 1.0e8;
                            data_map[msg_name].push_back(gps_point);
                            qDebug() << "gps_point[latitude]:" << gps_point["latitude"];
                            qDebug() << "gps_point[longitude]:" << gps_point["longitude"];
                        }
                    }
                    break;
                }
            }
        }
        
        if (data_map.count("vehicle_gps_position") && !data_map["vehicle_gps_position"].empty())
        {
            _flightMetadata["start_gps"] = data_map["vehicle_gps_position"].front();
            _flightMetadata["end_gps"] = data_map["vehicle_gps_position"].back();
        }

        QString originalFileName = QFileInfo(_logFilePath).fileName();
        QRegularExpression re("log_\\d+_");
        QString newFileName = QString(originalFileName).replace(re, "log_");
        _flightMetadata["log_file"] = newFileName;

        _flightMetadata["start_timestamp"] = QFileInfo(_logFilePath).birthTime().toString("yyyy-MM-dd hh:mm:ss");

    } catch (const std::exception& e) {
        qWarning() << "Error parsing ULog file:" << e.what();
        return false;
    }
    
    qDebug() << "--- Final Parsed Data (before sending) ---";
    qDebug() << QJsonDocument(_flightMetadata).toJson(QJsonDocument::Indented);

    return true;
}

void FirebaseUploader::uploadLogToStorage()
{
    QFile logFile(_logFilePath);
    if (!logFile.open(QIODevice::ReadOnly))
    {
        qWarning() << "Failed to open log file for upload:" << _logFilePath;
        this->deleteLater();
        return;
    }

    QByteArray fileData = logFile.readAll();
    logFile.close();

    QString originalFileName = QFileInfo(_logFilePath).fileName();
    QRegularExpression re("log_\\d+_");
    QString newFileName = QString(originalFileName).replace(re, "log_");

    qDebug() << "Original filename:" << originalFileName;
    qDebug() << "New filename for upload:" << newFileName;

    QString storagePath = QString("FlightLogs/%1/%2").arg(_droneTypeString, newFileName);
    
    QString url_string = QString("https://firebasestorage.googleapis.com/v0/b/%1/o?name=%2")
                      .arg(FIREBASE_STORAGE_BUCKET, QUrl::toPercentEncoding(storagePath));

    QNetworkRequest request{QUrl{url_string}};
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/octet-stream");

    qDebug() << "Uploading to Firebase Storage..." << newFileName;
    QNetworkReply* reply = _networkManager->post(request, fileData);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onStorageUploadFinished(reply);
    });
}

void FirebaseUploader::onStorageUploadFinished(QNetworkReply* reply)
{
    if (reply->error() == QNetworkReply::NoError)
    {
        QByteArray responseData = reply->readAll();
        QJsonDocument jsonResponse = QJsonDocument::fromJson(responseData);
        QString downloadToken = jsonResponse.object()["downloadTokens"].toString();
        QString objectName = jsonResponse.object()["name"].toString();

        _storageDownloadUrl = QString("https://firebasestorage.googleapis.com/v0/b/%1/o/%2?alt=media&token=%3")
                                  .arg(FIREBASE_STORAGE_BUCKET, QUrl::toPercentEncoding(objectName), downloadToken);

        qDebug() << "Storage upload successful. URL:" << _storageDownloadUrl;
        uploadMetadataToFirestore();
    }
    else
    {
        qWarning() << "Storage upload failed:" << reply->errorString();
        qWarning() << "Response:" << reply->readAll();
        this->deleteLater();
    }
    reply->deleteLater();
}

void FirebaseUploader::uploadMetadataToFirestore()
{
    _flightMetadata["logURL"] = _storageDownloadUrl;
    _flightMetadata["count"] = _newCount;
    
    QJsonObject firestoreDocument;
    QJsonObject fields;

    for (const QString& key : _flightMetadata.keys())
    {
        const QJsonValue& value = _flightMetadata.value(key);
        QJsonObject fieldValue;

        if (value.isObject())
            fieldValue["stringValue"] = QString(QJsonDocument(value.toObject()).toJson(QJsonDocument::Compact));
        else if (value.isString())
            fieldValue["stringValue"] = value.toString();
        else if (value.isDouble())
            fieldValue["doubleValue"] = value.toDouble();
        else if (value.isBool())
            fieldValue["booleanValue"] = value.toBool();
        else if (value.isUndefined() || value.isDouble())
            fieldValue["integerValue"] = QString::number(value.toInt());
        
        fields[key] = fieldValue;
    }
    firestoreDocument["fields"] = fields;

    QJsonDocument doc(firestoreDocument);
    QByteArray jsonData = doc.toJson();

    QString dateString = QFileInfo(_logFilePath).birthTime().toString("yyMMdd");
    QString customDocId = QString::number(_newCount) + dateString;

    qDebug() << "Using custom document ID:" << customDocId;

    QString url_string = QString("https://firestore.googleapis.com/v1/projects/%1/databases/(default)/documents/%2/%3?key=%4")
                      .arg(FIREBASE_PROJECT_ID, _droneTypeString, customDocId, FIREBASE_API_KEY);

    QNetworkRequest request{QUrl{url_string}};
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    qDebug() << "Uploading to Firestore with custom ID...";
    QNetworkReply* reply = _networkManager->sendCustomRequest(request, "PATCH", jsonData);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onFirestoreUploadFinished(reply);
    });
}

void FirebaseUploader::onFirestoreUploadFinished(QNetworkReply* reply)
{
    if (reply->error() == QNetworkReply::NoError)
        qDebug() << "Firestore upload successful!";
    else
    {
        qWarning() << "Firestore upload failed:" << reply->errorString();
        qWarning() << "Response:" << reply->readAll();
    }
    reply->deleteLater();
    this->deleteLater();
}