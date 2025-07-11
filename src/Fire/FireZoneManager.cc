#include "FireZoneManager.h"
#include <QtMath>
#include <QRandomGenerator>
#include <QDateTime>

// --- Constructor ---
FireZoneManager::FireZoneManager(QObject* parent)
    : QObject(parent) {}

// --- Trả danh sách fire zones ---
QVariantList FireZoneManager::fireZones() const {
    return _fireZoneList;
}

// --- Tạo ID ngắn ---
QString FireZoneManager::generateShortId(int length) const {
    quint64 randomValue = QRandomGenerator::global()->generate64();
    QString base36 = QString::number(static_cast<qint64>(randomValue), 36);
    return base36.rightJustified(length, '0', true);
}

// --- Sinh toạ độ ngẫu nhiên ---
QGeoCoordinate FireZoneManager::generateRandomFireZone(const QGeoCoordinate& origin, double minDistance, double maxDistance) {
    double radius = minDistance + QRandomGenerator::global()->generateDouble() * (maxDistance - minDistance);
    double bearing = QRandomGenerator::global()->generateDouble() * 360.0;

    double earthRadius = 6371000.0;
    double lat1 = qDegreesToRadians(origin.latitude());
    double lon1 = qDegreesToRadians(origin.longitude());
    double brng = qDegreesToRadians(bearing);

    double lat2 = qAsin(qSin(lat1) * qCos(radius / earthRadius) +
                        qCos(lat1) * qSin(radius / earthRadius) * qCos(brng));
    double lon2 = lon1 + qAtan2(qSin(brng) * qSin(radius / earthRadius) * qCos(lat1),
                                qCos(radius / earthRadius) - qSin(lat1) * qSin(lat2));

    return QGeoCoordinate(qRadiansToDegrees(lat2), qRadiansToDegrees(lon2));
}

// --- Tạo mới vùng cháy ---
void FireZoneManager::createFireZone(const QGeoCoordinate& coordinate,
                                     double radius,
                                     const QString& name,
                                     const QString& status,
                                     int severity,
                                     const QString& imageUrl,
                                     const QDateTime& timestamp)
{
    QVariantMap fire;
    fire["id"] = generateShortId();
    fire["coordinate"] = QVariant::fromValue(coordinate);
    fire["radius"] = radius;
    fire["name"] = name;
    fire["status"] = status;
    fire["severity"] = severity;
    fire["imageUrl"] = imageUrl;
    fire["timestamp"] = timestamp.isValid() ? timestamp : QDateTime::currentDateTime();  

    _fireZoneList.append(fire);
    emit fireZonesChanged();
}


// --- Xoá theo index ---
void FireZoneManager::deleteFireZone(int index) {
    if (index >= 0 && index < _fireZoneList.size()) {
        _fireZoneList.removeAt(index);
        emit fireZonesChanged();
    }
}

// --- Xoá theo id ---
void FireZoneManager::deleteFireZoneById(const QString& id) {
    for (int i = 0; i < _fireZoneList.size(); ++i) {
        QVariantMap fire = _fireZoneList[i].toMap();
        if (fire["id"].toString() == id) {
            _fireZoneList.removeAt(i);
            emit fireZonesChanged();
            return;
        }
    }
}

// --- Xoá tất cả ---
void FireZoneManager::clearAllFireZones() {
    _fireZoneList.clear();
    emit fireZonesChanged();
}
