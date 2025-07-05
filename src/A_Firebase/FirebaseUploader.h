#ifndef FIREBASEUPLOADER_H
#define FIREBASEUPLOADER_H

#include <QObject>
#include <QString>
#include <QNetworkAccessManager>
#include <QJsonObject>

class QNetworkReply;

class FirebaseUploader : public QObject
{
    Q_OBJECT
public:
    explicit FirebaseUploader(const QString& logFilePath, QObject *parent = nullptr);
    void startUpload();

private slots:
    void onCountFetchFinished(QNetworkReply* reply);
    void onStorageUploadFinished(QNetworkReply* reply);
    void onFirestoreUploadFinished(QNetworkReply* reply);

private:
    void fetchLatestCount();
    bool parseUlogFile();
    void uploadLogToStorage();
    void uploadMetadataToFirestore();

    QString                 _logFilePath;
    QNetworkAccessManager* _networkManager;
    QJsonObject             _flightMetadata;
    QString                 _droneTypeString;
    QString                 _storageDownloadUrl;
    int                     _newCount;
};

#endif // FIREBASEUPLOADER_H