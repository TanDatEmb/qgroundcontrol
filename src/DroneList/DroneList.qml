import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import QGroundControl.Palette

Rectangle {
    anchors.fill: parent
    color: qgcPal.window

    property var droneTypes: ["Quadcopter Type", "Hexacopter Type", "Octocopter Type"]
    property var droneMap: {
        "Quadcopter Type": [
            { name: "Quad A1", image: "qrc:/lists/Quadcopter/Quad1.png",
              material: "Khung hợp kim nhôm, cánh sợi carbon",
              structure: "Module camera 4K, cảm biến siêu âm, GPS tích hợp",
              usage: "Quan sát tầm gần, khảo sát địa hình, chụp ảnh độ phân giải cao",
              strengths: "Khả năng chịu gió cấp 6, pin 30 phút, điều khiển chính xác",
              link: "https://ctuav.vn/vi/ct-uav/" },
            { name: "Quad A2", image: "qrc:/lists/Quadcopter/Quad1.png",            
              material: "Khung hợp kim nhôm, cánh sợi carbon",
             structure: "Module camera 4K, cảm biến siêu âm, GPS tích hợp",
               usage: "Quan sát tầm gần, khảo sát địa hình, chụp ảnh độ phân giải cao",
              strengths: "Khả năng chịu gió cấp 6, pin 30 phút, điều khiển chính xác",
              link: "https://ctuav.vn/vi/ct-uav/" }
        ],
        "Hexacopter Type": [
            { name: "Hexa A1", image: "qrc:/lists/Quadcopter/Quad1.png",
              material: "Khung hợp kim nhôm, cánh sợi carbon",
              structure: "Module camera 4K, cảm biến siêu âm, GPS tích hợp",
              usage: "Quan sát tầm gần, khảo sát địa hình, chụp ảnh độ phân giải cao",
              strengths: "Khả năng chịu gió cấp 6, pin 30 phút, điều khiển chính xác",
              link: "https://ctuav.vn/vi/ct-uav/" },
            { name: "Hexa A2", image: "qrc:/lists/Quadcopter/Quad1.png",
              material: "Khung hợp kim nhôm, cánh sợi carbon",
              structure: "Module camera 4K, cảm biến siêu âm, GPS tích hợp",
              usage: "Quan sát tầm gần, khảo sát địa hình, chụp ảnh độ phân giải cao",
              strengths: "Khả năng chịu gió cấp 6, pin 30 phút, điều khiển chính xác",
              link: "https://ctuav.vn/vi/ct-uav/" }
        ],
        "Octocopter Type": [
            { name: "Octo A1", image: "qrc:/lists/Quadcopter/Quad1.png",
              material: "Khung hợp kim nhôm, cánh sợi carbon",
              structure: "Module camera 4K, cảm biến siêu âm, GPS tích hợp",
              usage: "Quan sát tầm gần, khảo sát địa hình, chụp ảnh độ phân giải cao",
              strengths: "Khả năng chịu gió cấp 6, pin 30 phút, điều khiển chính xác",
              link: "https://ctuav.vn/vi/ct-uav/" },
            { name: "Octo A2", image: "qrc:/lists/Quadcopter/Quad1.png",
              material: "Khung hợp kim nhôm, cánh sợi carbon",
              structure: "Module camera 4K, cảm biến siêu âm, GPS tích hợp",
              usage: "Quan sát tầm gần, khảo sát địa hình, chụp ảnh độ phân giải cao",
              strengths: "Khả năng chịu gió cấp 6, pin 30 phút, điều khiển chính xác",
              link: "https://ctuav.vn/vi/ct-uav/" }
        ]
    }

    property string selectedType: droneTypes[0]
    property bool isMobile: Screen.width <= 600

    property var selectedDrone: null
    property bool showDetailOverlay: false

    function onDroneItemClicked(drone) {
        selectedDrone = drone
        showDetailOverlay = true
    }

    Item {
    anchors.fill: parent

        // Row với 3 phần theo tỷ lệ 1 : 3 : 1
        Row {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            // Cột 1 - Danh sách loại drone (1 phần)
            Item {
                width: parent.width * 0.1 // Tỉ lệ 1
                height: parent.height

                ListView {
                    anchors.fill: parent
                    spacing: 8
                    model: droneTypes
                    delegate: Item {
                        width: parent.width
                        height: 40
                        property bool hovered: false

                        Rectangle {
                            anchors.fill: parent
                            radius: 4
                            border.color: "#3d81c2"
                            border.width: selectedType === modelData ? 1 : 0
                            color: selectedType === modelData ? "#3d81c2"
                                : hovered ? "#98ccff" : "transparent"

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: selectedType = modelData
                                onEntered: hovered = true
                                onExited: hovered = false
                                cursorShape: Qt.PointingHandCursor
                            }

                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                color: qgcPal.text
                                font.bold: true
                            }
                        }
                    }
                }
            }

            // Cột 2 - Danh sách drone theo loại (3 phần)
            Item {
                width: parent.width * 0.7 // Tỉ lệ 3
                height: parent.height

                GridView {
                    anchors.fill: parent
                    cellWidth: isMobile ? (width / 2) : (width / 4)
                    cellHeight: cellWidth + 60
                    model: droneMap[selectedType]

                    delegate: Column {
                        width: GridView.view.cellWidth
                        height: GridView.view.cellHeight
                        spacing: 4

                        Item {
                            width: parent.width * 0.9
                            height: width
                            anchors.horizontalCenter: parent.horizontalCenter

                            Rectangle {
                                id: droneCard
                                width: parent.width
                                height: parent.height
                                radius: 12
                                color: droneMouseArea.containsMouse ? "#e6f4ff" : qgcPal.window
                                border.color: droneMouseArea.containsMouse ? "#3d81c2" : "#3d82c2"
                                border.width: 1
                                clip: true

                                Image {
                                    anchors.fill: parent
                                    source: modelData.image
                                    fillMode: Image.PreserveAspectCrop
                                }

                                MouseArea {
                                    id: droneMouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: onDroneItemClicked(modelData)
                                    cursorShape: Qt.PointingHandCursor
                                }
                            }

                            DropShadow {
                                anchors.fill: droneCard
                                source: droneCard
                                radius: 12
                                samples: 24
                                color: "#55000000"
                                horizontalOffset: 2
                                verticalOffset: 4
                                visible: droneMouseArea.containsMouse
                            }
                        }

                        Text {
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                            text: modelData.name
                            font.pointSize: isMobile ? 12 : 16
                            color: qgcPal.text
                        }
                    }
                }
            }

            // Cột 3 - Chi tiết drone (1 phần)
            Item {
                id: detailPanelWrapper
                width: parent.width * 0.28
                height: parent.height
                Layout.alignment: Qt.AlignRight

                Rectangle {
                    id: overlay
                    anchors.fill: parent
                    color: "#00000060"
                    visible: selectedDrone !== null
                    z: 1

                    MouseArea {
                        anchors.fill: parent
                        onClicked: selectedDrone = null
                    }
                }

                Rectangle {
                    id: detailPanel
                    width: parent.width
                    height: parent.height
                    color: "#f4f4f4"
                    border.color: "#3d81c2"
                    border.width: 1
                    radius: 8
                    x: selectedDrone !== null ? 0 : parent.width
                    z: 2
                    clip: true
                    
                    Behavior on x {
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.InOutQuad
                        }
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 14

                        Text {
                            text: selectedDrone ? selectedDrone.name : ""
                            font.bold: true
                            font.pixelSize: 22
                            horizontalAlignment: Text.AlignLeft
                            Layout.alignment: Qt.AlignLeft
                            color: "#1f1f1f"
                        }

                        Rectangle {
                            Layout.preferredWidth: parent.width * 0.66667
                            Layout.preferredHeight: Layout.preferredWidth
                            Layout.alignment: Qt.AlignLeft
                            radius: 6
                            color: "transparent"
                            border.color: "#cccccc"

                            Image {
                                anchors.fill: parent
                                anchors.margins: 3
                                source: selectedDrone ? selectedDrone.image : ""
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        ScrollView {
                            Layout.preferredWidth: parent.width
                            Layout.fillHeight: parent.height * 0.9
                            Layout.alignment: Qt.AlignLeft
                            anchors.leftMargin: 20

                            contentItem: ColumnLayout {
                                width: parent.width
                                spacing: 6
                                
                                Text {
                                    text: "VẬT LIỆU SỬ DỤNG"
                                    font.pixelSize: 16; font.bold: true
                                    wrapMode: Text.WordWrap
                                    Layout.alignment: Qt.AlignLeft
                                }
                                Text {
                                    text: selectedDrone ? selectedDrone.material : ""
                                    wrapMode: Text.WordWrap
                                    font.pixelSize: 16
                                    color: "#333333"
                                    horizontalAlignment: Text.AlignLeft
                                    Layout.preferredWidth: parent.width * 0.7
                                }

                                Text {
                                    text: "CẤU TẠO"
                                    font.pixelSize: 16; font.bold: true
                                    wrapMode: Text.WordWrap
                                    Layout.alignment: Qt.AlignLeft
                                }
                                Text {
                                    text: selectedDrone ? selectedDrone.structure : ""
                                    wrapMode: Text.WordWrap
                                    font.pixelSize: 16
                                    color: "#333333"
                                    horizontalAlignment: Text.AlignLeft
                                    Layout.preferredWidth: parent.width * 0.7
                                }

                                Text {
                                    text: "CÔNG DỤNG"
                                    font.pixelSize: 16; font.bold: true
                                    wrapMode: Text.WordWrap
                                    Layout.alignment: Qt.AlignLeft
                                }
                                Text {
                                    text: selectedDrone ? selectedDrone.usage : ""
                                    wrapMode: Text.WordWrap
                                    font.pixelSize: 16
                                    color: "#333333"
                                    horizontalAlignment: Text.AlignLeft
                                    Layout.preferredWidth: parent.width * 0.7
                                }

                                Text {
                                    text: "ĐIỂM MẠNH"
                                    font.pixelSize: 16; font.bold: true
                                    wrapMode: Text.WordWrap
                                    Layout.alignment: Qt.AlignLeft
                                }
                                Text {
                                    text: selectedDrone ? selectedDrone.strengths : ""
                                    wrapMode: Text.WordWrap
                                    font.pixelSize: 16
                                    color: "#333333"
                                    horizontalAlignment: Text.AlignLeft
                                    Layout.preferredWidth: parent.width * 0.7
                                }
                            }
                        }

                        Item { Layout.fillHeight: true }

                        RowLayout {
                            spacing: 8
                            Layout.alignment: Qt.AlignLeft

                            Button {
                                text: "Thông tin liên hệ"
                                flat: false      // hoặc true nếu bạn muốn flat
                                font.pixelSize: 16
                                onClicked: {
                                    if (selectedDrone && selectedDrone.link) 
                                        Qt.openUrlExternally(selectedDrone.link)
                                }
                            }

                            Button {
                                text: "Done"
                                font.pixelSize: 16
                                // ép width nhỏ lại
                                Layout.preferredWidth: 80
                                Layout.minimumWidth: 80
                                onClicked: selectedDrone = null
                            }
                        }

                    }
                }
            }
        }
    }
}
