import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import QtLocation
import QtPositioning
import QtQuick.Effects

import QGroundControl
import QGroundControl.ScreenTools
import QGroundControl.Controls
import QGroundControl.Controllers
import QGroundControl.Palette
import QGroundControl.FlightMap

MapQuickItem {
    id: fireZoneItem

    property var object              ///< modelData từ MapItemView
    property var parentMap           ///< Để dùng toCoordinate/fromCoordinate
    coordinate: object && object.coordinate ? object.coordinate : QtPositioning.coordinate(0, 0)
    property double radius: object && object.radius !== undefined ? object.radius : 0  // Đơn vị: mét

    function metersToPixel(meters) {
        if (!parentMap || !parentMap.toCoordinate || !parentMap.fromCoordinate) {
            return 0
        }

        const coord1 = coordinate
        const coord2 = QtPositioning.coordinate(coord1.latitude, coord1.longitude + 0.00001)
        const point1 = parentMap.fromCoordinate(coord1)
        const point2 = parentMap.fromCoordinate(coord2)

        const distPx = Math.sqrt(Math.pow(point2.x - point1.x, 2) + Math.pow(point2.y - point1.y, 2))
        const distMeters = coord1.distanceTo(coord2)
        const pxPerMeter = distPx / distMeters
        return meters * pxPerMeter
    }

    anchorPoint.x: fireItem.width / 2
    anchorPoint.y: fireItem.height / 2
    visible: true

    // Component.onCompleted: {
    //     console.log("🔥 FireZone debug start ===========================")
    //     console.log("🔥 modelData:       ", JSON.stringify(modelData))
    //     console.log("🔥 object:          ", JSON.stringify(object))
    //     console.log("🔥 parentMap:       ", parentMap)
    //     console.log("🔥 coordinate:      Lat:", coordinate.latitude, " Lon:", coordinate.longitude, " Valid:", coordinate.isValid)
    //     console.log("🔥 radius (m):      ", radius)
    //     console.log("🔥 width (px):      ", metersToPixel(radius))
    //     console.log("🔥 FireZone debug end =============================")
    // }

    Connections {
        target: fireZoneItem.parentMap
        onZoomLevelChanged: {
            fireItem.width = fireZoneItem.metersToPixel(fireZoneItem.radius)
            fireItem.height = fireZoneItem.metersToPixel(fireZoneItem.radius)
        }
    }


    sourceItem: Item {
        id: fireItem
        width: fireZoneItem.parentMap ? fireZoneItem.metersToPixel(fireZoneItem.radius) : 0
        height: fireZoneItem.parentMap ? fireZoneItem.metersToPixel(fireZoneItem.radius) : 0

        // Behavior on width {
        //     NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
        // }
        // Behavior on height {
        //     NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
        // }

        Rectangle {
            width: fireItem.width
            height: width
            color: width < 32 ? "#00000000" : "#72ff3700" 
            radius: width / 2
            border.width: 2
            border.color: width < 32 ? "#00000000" : "#FF6600"


            Image {
                anchors.centerIn: parent
                source: "qrc:/res/Fire.svg"
                width: 32
                height: 32
                fillMode: Image.PreserveAspectFit
            }

        }

        MouseArea {
            anchors.fill: parent
            onClicked: fireInfoDialog.open()
        }

        Dialog {
            id: fireInfoDialog
            property int baseFontSize: 10  // 👈 Biến gốc để dễ chỉnh toàn cục

            width: 220
            height: 180
            modal: false
            dim: false
            standardButtons: Dialog.NoButton
            clip: true

            // background: Rectangle {
            //     color: "#a5222222"
            //     border.color: "#333333"
            //     border.width: 2
            //     radius: 8
            // }
            background: Rectangle {
                color: "#00222222"
                border.color: "#00333333"
                border.width: 2
                radius: 8
            }

            contentItem: Row {
                anchors.fill: parent
                spacing: 8

                // 👉 Cột thông tin bên phải
                Rectangle {
                    color: "#b2222222"
                    radius: 8
                    border.color: "#565656"
                    border.width: 1

                    width: parent.width - deleteButton.width - 24
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter

                    Column {
                        id: infoColumn
                        spacing: 6
                        anchors.fill: parent
                        anchors.margins: 6

                        Text {
                            text: qsTr("Thông tin vùng cháy")
                            color: "white"
                            font.bold: true
                            font.pixelSize: fireInfoDialog.baseFontSize * 1.2
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        ScrollView {
                            id: scrollView
                            clip: true
                            ScrollBar.vertical.policy: ScrollBar.AsNeeded
                            width: parent.width 
                            height: parent.height - 32

                            Column {
                                spacing: 6
                                width: parent.width

                                Text {
                                    text: qsTr("Tên: ") + (object.name ?? qsTr("Không rõ"))
                                    color: "white"
                                    font.bold: true
                                    font.pixelSize: fireInfoDialog.baseFontSize * 1.1
                                    wrapMode: Text.Wrap
                                }

                                Loader {
                                    active: object.imageUrl && object.imageUrl !== ""
                                    visible: active
                                    height: active ? parent.width : 0
                                    width: height

                                    sourceComponent: Rectangle {
                                        anchors.fill: parent
                                        radius: 8
                                        clip: true

                                        Image {
                                            anchors.fill: parent
                                            fillMode: Image.PreserveAspectCrop
                                            source: object.imageUrl
                                            smooth: true
                                        }
                                    }
                                }

                                Text {
                                    text: qsTr("Lat: ") + fireZoneItem.coordinate.latitude.toFixed(6)
                                    color: "white"
                                    font.pixelSize: fireInfoDialog.baseFontSize
                                }

                                Text {
                                    text: qsTr("Lon: ") + fireZoneItem.coordinate.longitude.toFixed(6)
                                    color: "white"
                                    font.pixelSize: fireInfoDialog.baseFontSize
                                }

                                Text {
                                    text: qsTr("Bán kính: ") + fireZoneItem.radius.toFixed(2) + " m"
                                    color: "white"
                                    font.pixelSize: fireInfoDialog.baseFontSize
                                }

                                Text {
                                    text: qsTr("Trạng thái: ") + (object.status ?? "Chưa xác định")
                                    color: "white"
                                    font.pixelSize: fireInfoDialog.baseFontSize
                                }

                                Text {
                                    text: qsTr("Mức độ: ") + (object.severity ?? "N/A")
                                    color: "white"
                                    font.pixelSize: fireInfoDialog.baseFontSize
                                }

                                Text {
                                    text: qsTr("Bắt đầu: ") + (object.timestamp ? new Date(object.timestamp).toLocaleString() : "Không rõ")
                                    color: "white"
                                    font.pixelSize: fireInfoDialog.baseFontSize
                                    wrapMode: Text.Wrap
                                    width: parent.width
                                    elide: Text.ElideRight
                                }
                            }
                        }
                    }
                }


                // 👉 Nút xoá nằm bên trái
                Button {
                    id: deleteButton
                    width: 32
                    height: 32

                    background: Rectangle {
                        color: "#222"
                        border.color: "#353535"
                        border.width: 1
                        radius: 8
                    }

                    contentItem: Image {
                        source: "qrc:/res/TrashDelete.svg"
                        anchors.centerIn: parent
                        width: 14
                        height: 14
                        fillMode: Image.PreserveAspectFit
                    }

                    onClicked: {
                        if (object && object.id) {
                            fireManager.deleteFireZoneById(object.id)
                            fireInfoDialog.close()
                        }
                    }
                }

            }
        }


    }
}
