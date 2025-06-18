import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import QGroundControl.Palette

Rectangle {
    anchors.fill: parent
    color: qgcPal.window

    property var droneTypes: ["Quadcopter Type", "Hexacopter Type", "Lightshow", "Firefighting"]
    property var droneMap: {
        "Quadcopter Type": [
            {
                "name": "Quad N1",
                "image": "qrc:/lists/4-axis-5kg.png",
                "structure_type": "Folded structure",
                "material": "Carbon fiber, ABS, Aluminum alloy",
                "size": "Folded: 345×435×500 mm, Unfolded: 710×710×800 mm",
                "number_of_axes": "4",
                "wheelbase": "900 mm",
                "weight": "3.5 kg (including battery 2.6 kg)",
                "loading": "3~6 kg",
                "flightspeed": "10~15 m/s",
                "Height": "< 5000 m (Customized on demand)",
                "max_remote_control": "0~15 km (no interference) (Customized on demand)",
                "power_mode": "Pure electricity",
                "operating_temp": "-10 to +60°C",
                "max_tilt_angle": "45°",
                "max_rising_speed": "5 m/s",
                "max_down_speed": "3 m/s",
                "max_resist_wind_speed": "< 13.8 m/s (Force 6 wind)",
                "overing_time": "No load: 65 minutes, Full load: 20~30 minutes",
                "battery": "6S 30000 mAh (Customized on demand)",
                "propeller": "22×70",
                "camera": "4K HD 6x hybrid zoom (Customized on demand)",
                "code": "CT-HV-5D-4",
                "link": "https://ctuav.vn/vi/ct-uav/"
            },
            {
                "name": "Quad N2",
                "image": "qrc:/lists/4-axis-12kg.png",
                "structure_type": "Folded structure",
                "material": "Carbon fiber, ABS, Aluminum alloy",
                "size": "Folded: 620×620×600 mm, Unfolded: 1100×1100×600 mm",
                "number_of_axes": "4",
                "wheelbase": "1400 mm",
                "weight": "32 kg (including battery 12 kg)",
                "loading": "6~12 kg",
                "flightspeed": "10~15 m/s",
                "Height": "< 5000 m (Customized on demand)",
                "max_remote_control": "0~15 km (no interference) (Customized on demand)",
                "power_mode": "Pure electricity",
                "operating_temp": "-10 to +60°C",
                "max_tilt_angle": "45°",
                "max_rising_speed": "5 m/s",
                "max_down_speed": "3 m/s",
                "max_resist_wind_speed": "< 13.8 m/s (Force 6 wind)",
                "overing_time": "No load: 80 minutes, Full load: 20~35 minutes",
                "battery": "14S 54000 mAh (Customized on demand)",
                "propeller": "36 inches",
                "camera": "4K HD 6x hybrid zoom (Customized on demand)",
                "code": "CT-HV-12D-4",
                "link": "https://ctuav.vn/vi/ct-uav/"
            },
            {
                "name": "Quad S1",
                "image": "qrc:/lists/4-axis-UAV.png",
                "structure_type": "Folded structure",
                "material": "Carbon fiber, ABS, Aluminum alloy",
                "size": "Folded: 630×1250×700 mm, Unfolded: 1900×1720×700 mm",
                "number_of_axes": "4",
                "wheelbase": "2300 mm",
                "weight": "30 kg (without battery)",
                "loading": "25~35 kg",
                "flightspeed": "10~15 m/s",
                "Height": "< 4000 m (Customized on demand)",
                "max_remote_control": "0~30 km (no interference) (Customized on demand)",
                "power_mode": "Pure electricity",
                "operating_temp": "-10 to +60°C",
                "max_tilt_angle": "45°",
                "max_rising_speed": "5 m/s",
                "max_down_speed": "3 m/s",
                "max_resist_wind_speed": "< 13.8 m/s (Force 6 wind)",
                "overing_time": "No load: 60 minutes, Full load: 20~35 minutes",
                "battery": "18S 46000 mAh ×2 (Customized on demand)",
                "propeller": "56 inches",
                "camera": "2K HD 30x hybrid zoom (Customized on demand)",
                "code": "CT-HV-25D-4",
                "link": "https://ctuav.vn/vi/ct-uav/"
            }
        ],
        "Hexacopter Type": [
            {
                "name": "Hexa S1",
                "image": "qrc:/lists/6-axis-UAV.png",
                "structure_type": "Folded structure",
                "material": "Carbon fiber, ABS, Aluminum alloy",
                "size": "Folded: 1000×1000×800 mm, Unfolded: 2000×2000×800 mm",
                "number_of_axes": "6",
                "wheelbase": "1900 mm",
                "weight": "31 kg (including battery 12 kg)",
                "loading": "20~30 kg",
                "flightspeed": "10~15 m/s",
                "Height": "< 4000 m (Customized on demand)",
                "max_remote_control": "0~30 km (no interference) (Customized on demand)",
                "power_mode": "Pure electricity",
                "operating_temp": "-10 to +60°C",
                "max_tilt_angle": "45°",
                "max_rising_speed": "5 m/s",
                "max_down_speed": "3 m/s",
                "max_resist_wind_speed": "< 13.8 m/s (Force 6 wind)",
                "overing_time": "No load: 60 minutes, Full load: 20~30 minutes",
                "battery": "14S 30000 mAh ×2 (Customized on demand)",
                "propeller": "36 inches",
                "camera": "2K HD 30x hybrid zoom (Customized on demand)",
                "code": "CT-HV-25D-6",
                "link": "https://ctuav.vn/vi/ct-uav/"
            }
        ],
        "Lightshow": [
            {
                "name": "Lightshow UAV",
                "image": "qrc:/lists/Lightshow.png",
                "size": "500×500×210 mm (Customized on demand)",
                "material": "Carbon fiber, ABS, Aluminum alloy",
                "number_of_axes": "4",
                "location_mode": "GPS + BD + RTK",
                "weight": "1.8 kg",
                "performance_flight_speed": "4 m/s",
                "flightspeed": "22 m/s",
                "minimum_air_spacing": "3 m",
                "floor_spacing": "1~1.5 m",
                "horizontal_positioning_accuracy": "±0.02 m (RTK), ±0.5 m (GPS)",
                "vertical_positioning_accuracy": "±0.02 m (RTK), ±1 m (GPS)",
                "max_number_formations": "10000 units",
                "load_type": "LED, colored smoke, fireworks, cannons",
                "communication_mode": "433M, 918M, 2.4G, 5.8G",
                "operating_temp": "-10 to +60°C",
                "battery": "4S 6000 mAh",
                "overing_time": "60 minutes (at 10 m/s)",
                "Height": "< 1000 m (Customized on demand)",
                "max_remote_control": "0~15 km (no interference) (Customized on demand)",
                "LED_color": "32-bit",
                "LED_power": "0~24W",
                "working_mode": "Offline mode",
                "code": "S3-PRO",
                "link": "https://ctuav.vn/vi/ct-uav/"
            }
        ],
        "Firefighting": [
            {
                "name": "Firefighting UAV",
                "image": "qrc:/lists/Firefighting.png",
                "structure_type": "Folded structure",
                "material": "Carbon fiber, ABS, Aluminum alloy",
                "size": "Folded: 1000×1000×800 mm, Unfolded: 2000×2000×800 mm",
                "number_of_axes": "6",
                "wheelbase": "1900 mm",
                "weight": "31 kg (including battery weight 12 kg)",
                "loading": "25 kg",
                "flightspeed": "10~15 m/s",
                "Height": "< 4000 m (Customized on demand)",
                "max_remote_control": "0~30 km (no interference) (Customized on demand)",
                "power_mode": "Pure electricity",
                "operating_temp": "-10 to +60°C",
                "max_tilt_angle": "45°",
                "max_rising_speed": "5 m/s",
                "max_down_speed": "3 m/s",
                "max_resist_wind_speed": "< 13.8 m/s (Force 6 wind)",
                "overing_time": "No load: 60 min, Full load: 20~30 min",
                "battery": "14S 30000 mAh ×2 (Customized on demand)",
                "propeller": "36 inches",
                "camera": "4K AI 180× hybrid zoom (Customized on demand)",
                "code": "CT-HV-25D-6-F",
                "link": "https://ctuav.vn/vi/ct-uav/"
            }
        ],
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

            // Cột 1 - Danh sách loại drone
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

            // Cột 2 - Danh sách drone theo loại
            Item {
                width: parent.width * 0.9 // Tỉ lệ 3
                height: parent.height

                GridView {
                    anchors.fill: parent
                    cellWidth: isMobile ? (width / 3) : (width / 6)
                    cellHeight: cellWidth + 60
                    model: droneMap[selectedType]

                    delegate: Column {
                        width: GridView.view.cellWidth
                        height: GridView.view.cellHeight
                        spacing: 4

                        Item {
                            width: parent.width * 0.8
                            height: width
                            anchors.horizontalCenter: parent.horizontalCenter

                            Rectangle {
                                id: droneCard
                                width: parent.width
                                height: parent.height
                                radius: 8
                                color: qgcPal.window
                                border.color: droneMouseArea.containsMouse ? "#0069b4" :"#333333"
                                border.width: 1
                                clip: true

                                Image {
                                    anchors.fill: parent
                                    source: modelData.image
                                    fillMode: Image.PreserveAspectFit
                                }

                                MouseArea {
                                    id: droneMouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: onDroneItemClicked(modelData)
                                    cursorShape: Qt.PointingHandCursor
                                }
                                Text {
                                    width: parent.width
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 8
                                    horizontalAlignment: Text.AlignHCenter
                                    wrapMode: Text.WordWrap
                                    text: modelData.name
                                    font.pointSize: isMobile ? 12 : 16
                                    color: qgcPal.text
                                }
                            }

                            DropShadow {
                                anchors.fill: droneCard
                                source: droneCard
                                radius: 12
                                samples: 24
                                color: "#9f101010"
                                horizontalOffset: 2
                                verticalOffset: 4
                                visible: droneMouseArea.containsMouse
                            }
                        }

                        
                    }
                }
            }
        }

        // Cột 3 - Chi tiết drone
        Item {
            id: detailPanelWrapper
            anchors.fill: parent
            z: 10

            // Nền đen mờ phủ toàn màn hình
            Rectangle {
                id: overlay
                anchors.fill: parent
                color: "#bc1f1f1f"
                visible: showDetailOverlay
                z: 1
                opacity: showDetailOverlay ? 1 : 0

                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // Kích hoạt animation đóng panel
                        showDetailOverlay = false
                        selectedDrone = null
                    }
                }
            }

            // Panel
            Rectangle {
                id: detailPanel
                width: parent.width * 0.4
                height: parent.height
                color: qgcPal.globalTheme === QGCPalette.Light ? "#f4f4f4" : "#2b2b2b"
                border.color: qgcPal.globalTheme === QGCPalette.Light ? "#3d81c2" : "#aaaaaa"
                border.width: 1
                radius: 8
                z: 2
                clip: true

                x: showDetailOverlay ? parent.width - width : parent.width

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

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true

                        Column {
                            width: detailPanel.width - 60
                            spacing: 14
                            padding: 6

                            Column {
                                spacing: 12
                                Row {
                                    spacing: 12
                                    Rectangle {
                                        width: detailPanel.width * 0.285
                                        height: width
                                        color: "white"
                                        border.color: "#ccc"
                                        radius: 6

                                        Image {
                                            anchors.fill: parent
                                            anchors.margins: 4
                                            source: selectedDrone ? selectedDrone.image : ""
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                    Column {
                                        spacing: 8

                                        Text {
                                            text: selectedDrone ? selectedDrone.name : ""
                                            font.pixelSize: 18
                                            font.bold: true
                                            color: qgcPal.globalTheme === QGCPalette.Light ? "black" : "white"
                                        }

                                        Text {
                                            text: selectedDrone ? "Mã: " + selectedDrone.code : ""
                                            font.pixelSize: 16
                                            color: qgcPal.globalTheme === QGCPalette.Light ? "black" : "white"
                                        }
                                    }
                                }

                                Column {
                                    spacing: 4

                                    Text {
                                        text: "Mô tả:"
                                        font.bold: true
                                        font.pixelSize: 16
                                        color: qgcPal.globalTheme === QGCPalette.Light ? "black" : "white"
                                    }

                                    Text {
                                        text: selectedDrone ? selectedDrone.description : ""
                                        wrapMode: Text.WordWrap
                                        font.pixelSize: 16
                                        color: qgcPal.globalTheme === QGCPalette.Light ? "black" : "white"
                                    }
                                }
                            }

                            Repeater {
                                model: selectedDrone ? [
                                    { label: "Cấu trúc", value: selectedDrone.structure_type },
                                    { label: "Chất liệu", value: selectedDrone.material },
                                    { label: "Kích thước", value: selectedDrone.size },
                                    { label: "Số trục", value: selectedDrone.number_of_axes },
                                    { label: "Chiều dài trục", value: selectedDrone.wheelbase },
                                    { label: "Trọng lượng", value: selectedDrone.weight },
                                    { label: "Tải trọng", value: selectedDrone.loading },
                                    { label: "Tốc độ bay", value: selectedDrone.flightspeed },
                                    { label: "Chiều cao tối đa", value: selectedDrone.Height },
                                    { label: "Tầm điều khiển", value: selectedDrone.max_remote_control },
                                    { label: "Chế độ nguồn", value: selectedDrone.power_mode },
                                    { label: "Nhiệt độ hoạt động", value: selectedDrone.operating_temp },
                                    { label: "Góc nghiêng tối đa", value: selectedDrone.max_tilt_angle },
                                    { label: "Tốc độ lên", value: selectedDrone.max_rising_speed },
                                    { label: "Tốc độ xuống", value: selectedDrone.max_down_speed },
                                    { label: "Chống gió", value: selectedDrone.max_resist_wind_speed },
                                    { label: "Thời gian bay", value: selectedDrone.overing_time },
                                    { label: "Pin", value: selectedDrone.battery },
                                    { label: "Cánh quạt", value: selectedDrone.propeller },
                                    { label: "Camera", value: selectedDrone.camera },
                                    { label: "Màu LED", value: selectedDrone.LED_color },
                                    { label: "Công suất LED", value: selectedDrone.LED_power },
                                    { label: "Loại tải", value: selectedDrone.load_type },
                                    { label: "Giao tiếp", value: selectedDrone.communication_mode },
                                    { label: "Chế độ hoạt động", value: selectedDrone.working_mode },
                                    { label: "Định vị", value: selectedDrone.location_mode }
                                ].filter(entry => entry.value !== undefined) : []

                                delegate: Row {
                                    spacing: 8
                                    Text {
                                        text: modelData.label + ":"
                                        font.pixelSize: 15
                                        font.bold: true
                                        width: 180
                                        wrapMode: Text.WordWrap
                                        color: qgcPal.globalTheme === QGCPalette.Light ? "black" : "white"
                                    }
                                    Text {
                                        text: modelData.value
                                        font.pixelSize: 15
                                        width: detailPanel.width - 260
                                        wrapMode: Text.WordWrap
                                        color: qgcPal.globalTheme === QGCPalette.Light ? "black" : "white"
                                    }
                                }
                            }
                        }
                        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                    }

                    RowLayout {
                        spacing: 8
                        Layout.alignment: Qt.AlignLeft

                        Button {
                            text: "Thông tin liên hệ"
                            flat: false 
                            font.pixelSize: 16
                            onClicked: {
                                if (selectedDrone && selectedDrone.link) 
                                    Qt.openUrlExternally(selectedDrone.link)
                            }
                            background: Rectangle {
                                color: qgcPal.globalTheme === QGCPalette.Light ? "#9fc5e8" : "#ccc"
                                radius: 12
                            }
                        }

                        Button {
                            text: "Done"
                            font.pixelSize: 16
                            Layout.preferredWidth: 80
                            Layout.minimumWidth: 80
                            onClicked: selectedDrone = null

                            background: Rectangle {
                                color: qgcPal.globalTheme === QGCPalette.Light ? "#9fc5e8" : "#ccc"
                                radius: 12
                            }
                        }
                    }
                }
            }
        }
    }
}