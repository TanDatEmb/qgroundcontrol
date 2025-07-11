#pragma once

#include <QObject>
#include <QtPositioning/QGeoCoordinate>
#include <QVariantList>
#include <QDateTime>

class FireZoneManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList fireZones READ fireZones NOTIFY fireZonesChanged)

public:
    explicit FireZoneManager(QObject* parent = nullptr);

    Q_INVOKABLE QGeoCoordinate generateRandomFireZone(const QGeoCoordinate& origin, double minDistance, double maxDistance);
    Q_INVOKABLE void createFireZone(const QGeoCoordinate& coordinate,
                                    double radius,
                                    const QString& name = "",
                                    const QString& status = "Đang cháy",
                                    int severity = 3,
                                    const QString& imageUrl = "",
                                    const QDateTime& timestamp = QDateTime());

    
    Q_INVOKABLE void deleteFireZone(int index);
    Q_INVOKABLE void deleteFireZoneById(const QString& id);
    Q_INVOKABLE void clearAllFireZones();

    QVariantList fireZones() const;

signals:
    void fireZonesChanged();

private:
    QVariantList _fireZoneList;
    QString generateShortId(int length = 8) const;
};
