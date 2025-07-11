#ifndef FIREBASEUPLOADER_H
#define FIREBASEUPLOADER_H

#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QObject>
#include <QProcess>
#include <QString>
#include <QTemporaryDir>

class QNetworkReply;

class FirebaseUploader : public QObject {
    Q_OBJECT
   public:
    explicit FirebaseUploader(const QString& logFilePath, const QString& uniqueKey, QObject* parent = nullptr);
    void startUpload();

   signals:
    void uploadFinished(const QString& uniqueKey, const QString& finalStatus);

   private slots:
    void onCountFetchFinished(QNetworkReply* reply);
    void onStorageUploadFinished(QNetworkReply* reply);
    void onFirestoreUploadFinished(QNetworkReply* reply);
    void onPythonScriptFinished(int exitCode, QProcess::ExitStatus exitStatus);
    void onHtmlUploadFinished(QNetworkReply* reply);

   private:
    void fetchLatestCount();
    bool parseUlogFile();
    void uploadLogToStorage();
    void runFlightReviewScript();
    void uploadHtmlReport(const QString& htmlFilePath);
    void uploadMetadataToFirestore();

    QString _logFilePath;
    QString _uniqueKey;
    QNetworkAccessManager* _networkManager;
    QJsonObject _flightMetadata;
    QString _droneTypeString;
    QString _storageDownloadUrl;
    QString _htmlReportUrl;
    int _newCount;
    QProcess* _pythonProcess;
    QTemporaryDir* _tempDir;
};

#endif  // FIREBASEUPLOADER_H