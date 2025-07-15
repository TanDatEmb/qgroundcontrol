import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import QGroundControl
import QGroundControl.Controls
import QGroundControl.Controllers
import QGroundControl.Palette



Rectangle {
    anchors.fill: parent
    color: qgcPal.window
    // color: detailPageLoader.active ? "transparent" : qgcPal.window

    property var droneTypes: ["Quadcopter Type", "Hexacopter Type", "Lightshow", "Firefighting"]
    property var droneMap: {
        "Quadcopter Type": [
            {   
                "id": 1,
                "name": "Quad N1",
                "image": "qrc:/lists/4_axis_UAV_5kg.png",
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
                "link": "https://ctuav.vn/vi/ct-uav/",
                "gallery": [
                    "qrc:/lists/4_axis_UAV_5kg.png",
                    "qrc:/lists/4_axis_UAV_5kg/1.png",
                    "qrc:/lists/4_axis_UAV_5kg/2.png",
                    "qrc:/lists/4_axis_UAV_5kg/3.png",
                    "qrc:/lists/4_axis_UAV_5kg/4.png",
                    "qrc:/lists/4_axis_UAV_5kg/5.png",
                    "qrc:/lists/4_axis_UAV_5kg/6.png",
                    "qrc:/lists/4_axis_UAV_5kg/7.png",
                ]

            },
            {
                "id": 2,
                "name": "Quad N2",
                "image": "qrc:/lists/4_axis_UAV_12kg.png",
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
                "link": "https://ctuav.vn/vi/ct-uav/",
                "gallery": [
                    "qrc:/lists/4_axis_UAV_12kg.png",
                    "qrc:/lists/4_axis_UAV_12kg/1.png",
                    "qrc:/lists/4_axis_UAV_12kg/2.png",
                    "qrc:/lists/4_axis_UAV_12kg/3.png",
                    "qrc:/lists/4_axis_UAV_12kg/4.png",
                    "qrc:/lists/4_axis_UAV_12kg/5.png",
                    "qrc:/lists/4_axis_UAV_12kg/6.png",
                    "qrc:/lists/4_axis_UAV_12kg/7.png",
                ]   
            },
            {
                "id": 3,
                "name": "Quad S1",
                "image": "qrc:/lists/4-axis_UAV_parameter.png",
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
                "link": "https://ctuav.vn/vi/ct-uav/",
                "gallery": [
                    "qrc:/lists/4-axis_UAV_parameter.png",
                    "qrc:/lists/4-axis_UAV_parameter/1.png",
                    "qrc:/lists/4-axis_UAV_parameter/2.png",
                    "qrc:/lists/4-axis_UAV_parameter/3.png",
                    "qrc:/lists/4-axis_UAV_parameter/4.png",
                    "qrc:/lists/4-axis_UAV_parameter/5.png",
                    "qrc:/lists/4-axis_UAV_parameter/6.png",
                    "qrc:/lists/4-axis_UAV_parameter/7.png"
                ] 
            }
        ],
        "Hexacopter Type": [
            {
                "id": 4,
                "name": "CT-HV-25D-6",
                "image": "qrc:/lists/6-CT-HV-25D-6.png",
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
                "link": "https://ctuav.vn/vi/ct-uav/",
                "gallery": [
                    "qrc:/lists/6-CT-HV-25D-6.png",
                    "qrc:/lists/6-CT-HV-25D-6/1.png",
                    "qrc:/lists/6-CT-HV-25D-6/2.png",
                    "qrc:/lists/6-CT-HV-25D-6/3.png",
                    "qrc:/lists/6-CT-HV-25D-6/4.png",
                    "qrc:/lists/6-CT-HV-25D-6/5.png",
                    "qrc:/lists/6-CT-HV-25D-6/6.png",
                    "qrc:/lists/6-CT-HV-25D-6/7.png",
                    "qrc:/lists/6-CT-HV-25D-6/8.png",
                    "qrc:/lists/6-CT-HV-25D-6/9.png",
                ] 
            }
        ],
        "Lightshow": [
            {
                "id": 5,
                "name": "S3-PRO",
                "image": "qrc:/lists/lightshow-S3-PRO.png",
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
                "link": "https://ctuav.vn/vi/ct-uav/",
                "gallery": [
                    "qrc:/lists/lightshow-S3-PRO.png",
                    "qrc:/lists/lightshow-S3-PRO/1.png",
                    "qrc:/lists/lightshow-S3-PRO/2.png",
                    "qrc:/lists/lightshow-S3-PRO/3.png",
                    "qrc:/lists/lightshow-S3-PRO/4.png",
                    "qrc:/lists/lightshow-S3-PRO/5.png",
                    "qrc:/lists/lightshow-S3-PRO/6.png",
                ]  
            }
        ],
        "Firefighting": [
            {
                "id": 6,
                "name": "Firefighting UAV",
                "image": "qrc:/lists/6-Fire_fighting_UAV_parameters.png",
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
                "link": "https://ctuav.vn/vi/ct-uav/",
                "gallery": [
                    "qrc:/lists/6-Fire_fighting_UAV_parameters.png",
                    "qrc:/lists/6-Fire_fighting_UAV_parameters/1.png",
                    "qrc:/lists/6-Fire_fighting_UAV_parameters/2.png",
                    "qrc:/lists/6-Fire_fighting_UAV_parameters/3.png",
                    "qrc:/lists/6-Fire_fighting_UAV_parameters/4.png",
                    "qrc:/lists/6-Fire_fighting_UAV_parameters/5.png",
                    "qrc:/lists/6-Fire_fighting_UAV_parameters/6.png",
                    "qrc:/lists/6-Fire_fighting_UAV_parameters/7.png",
                    "qrc:/lists/6-Fire_fighting_UAV_parameters/8.png",
                ]  
            }
        ],
    }

    property int fontSize: 14
    
    property string selectedType: droneTypes[0]
    property bool isMobile: Screen.width <= 600

    property var selectedDrone: null
    property bool showDetailOverlay: false

    property bool showImageGallery: false


    function onDroneItemClicked(drone) {
        selectedDrone = drone
        // detailPageLoader.active = true
        showDetailOverlay = true
    }

    Item {
        id: droneListWrapper
        anchors.fill: parent
        visible: true

        // visible: !detailPageLoader.active

        // Row với 3 phần
        Row {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            // Cột 1 - Danh sách loại drone (1 phần)
            Item {
                width: parent.width * 0.15 // Tỉ lệ 1
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
                                color: qgcPal.globalTheme === QGCPalette.Light ? selectedType === modelData ? "#fff" : qgcPal.text : qgcPal.text
                                font.pixelSize: fontSize * 1.2
                                font.bold: true
                            }
                        }
                    }
                }
            }

            // Cột 2 - Danh sách drone theo loại (3 phần)
            Item {
                width: parent.width * 0.85 // Tỉ lệ 3
                height: parent.height

                GridView {
                    anchors.fill: parent
                    cellWidth: isMobile ? (width / 3.2) : (width / 5)
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
                                    font.pixelSize: fontSize * 1.2
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

        // Cột 3 - Chi tiết drone (1 phần)
        Item {
            id: detailPanelWrapper
            anchors.fill: parent
            z: 10
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
                        showDetailOverlay = false
                        selectedDrone = null
                    }
                }
            }
            Rectangle {
                id: detailPanel
                width: parent.width * 0.5
                height: parent.height
                color: qgcPal.window
                border.color:  "#3b3b3b"
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
                                    width: detailPanel.width * 0.4
                                    height: width
                                    color: qgcPal.window
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
                                        font.pixelSize: fontSize * 2
                                        font.bold: true
                                        color: qgcPal.text
                                        wrapMode: Text.WordWrap
                                    }

                                    Text {
                                        text: selectedDrone ? qsTr("Code: ") + selectedDrone.code : ""
                                        font.pixelSize: fontSize * 1.2
                                        color: qgcPal.text
                                        wrapMode: Text.WordWrap
                                    }
                                    Item {
                                        width: 160
                                        height: 30

                                        Rectangle {
                                            anchors.fill: parent
                                            radius: 4
                                            color: mouseArea1.pressed ? "#444" : (mouseArea1.containsMouse ? "#333" : "#111")
                                            border.color: "#666"
                                            border.width: 1

                                            Text {
                                                anchors.centerIn: parent
                                                text: qsTr("See more photos")
                                                color: "white"
                                                font.pixelSize: fontSize
                                            }

                                            MouseArea {
                                                id: mouseArea1
                                                anchors.fill: parent
                                                onClicked: {
                                                    showImageGallery = true
                                                    // if (selectedDrone && selectedDrone.link)
                                                    //     Qt.openUrlExternally(selectedDrone.link)
                                                }
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                            }
                                        }
                                    }
                                }
                            }
                            Column {
                                spacing: 4

                                Text {
                                    text: qsTr("Describe:")
                                    font.bold: true
                                    color: qgcPal.text
                                    font.pixelSize: fontSize * 1.2
                                }

                                Text {
                                    text: selectedDrone.description ? selectedDrone.description : qsTr("No description available")
                                    wrapMode: Text.WordWrap
                                    font.pixelSize: fontSize
                                    color: qgcPal.text

                                }
                            }
                        }

                        Repeater {
                            model: selectedDrone ? [
                                { label: qsTr("Structure"), value: selectedDrone.structure_type },
                                { label: qsTr("Material"), value: selectedDrone.material },
                                { label: qsTr("Size"), value: selectedDrone.size },
                                { label: qsTr("Number of Axes"), value: selectedDrone.number_of_axes },
                                { label: qsTr("Wheelbase"), value: selectedDrone.wheelbase },
                                { label: qsTr("Weight"), value: selectedDrone.weight },
                                { label: qsTr("Payload"), value: selectedDrone.loading },
                                { label: qsTr("Flight Speed"), value: selectedDrone.flightspeed },
                                { label: qsTr("Max Altitude"), value: selectedDrone.Height },
                                { label: qsTr("Control Range"), value: selectedDrone.max_remote_control },
                                { label: qsTr("Power Mode"), value: selectedDrone.power_mode },
                                { label: qsTr("Operating Temperature"), value: selectedDrone.operating_temp },
                                { label: qsTr("Max Tilt Angle"), value: selectedDrone.max_tilt_angle },
                                { label: qsTr("Ascending Speed"), value: selectedDrone.max_rising_speed },
                                { label: qsTr("Descending Speed"), value: selectedDrone.max_down_speed },
                                { label: qsTr("Wind Resistance"), value: selectedDrone.max_resist_wind_speed },
                                { label: qsTr("Flight Time"), value: selectedDrone.overing_time },
                                { label: qsTr("Battery"), value: selectedDrone.battery },
                                { label: qsTr("Propeller"), value: selectedDrone.propeller },
                                { label: qsTr("Camera"), value: selectedDrone.camera },
                                { label: qsTr("LED Color"), value: selectedDrone.LED_color },
                                { label: qsTr("LED Power"), value: selectedDrone.LED_power },
                                { label: qsTr("Load Type"), value: selectedDrone.load_type },
                                { label: qsTr("Communication Mode"), value: selectedDrone.communication_mode },
                                { label: qsTr("Working Mode"), value: selectedDrone.working_mode },
                                { label: qsTr("Location Mode"), value: selectedDrone.location_mode }
                            ].filter(entry => entry.value !== undefined) : []

                            delegate: Row {
                                spacing: 8
                                Text {
                                    text: modelData.label + ":"
                                    font.bold: true
                                    font.pixelSize: fontSize
                                    width: 80
                                    wrapMode: Text.WordWrap
                                    color: qgcPal.text
                                }
                                Text {
                                    text: modelData.value
                                    width: detailPanel.width - 170
                                    font.pixelSize: fontSize
                                    wrapMode: Text.WordWrap
                                    color: qgcPal.text
                                }
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    spacing: 8

                    Item {
                        width: 80
                        height: 30

                        Rectangle {
                            anchors.fill: parent
                            radius: 4
                            color: qgcPal.globalTheme === QGCPalette.Light ?  mouseArea2.pressed ? "#333" : "#222" : mouseArea2.pressed ? "#0061a2" : "#0070ba"

                            Text {
                                anchors.centerIn: parent
                                text: qsTr("Confirm")
                                color: "white"
                                font.pixelSize: fontSize
                            }

                            MouseArea {
                                id: mouseArea2
                                anchors.fill: parent
                                onClicked: {
                                    showDetailOverlay = false
                                    selectedDrone = null
                                }
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }
                }


            }

            }

        }

       Rectangle {
            id: imageGalleryOverlay
            anchors.fill: parent
            color:  "#80000000" 
            visible: showImageGallery
            z: 99

            MouseArea {
                anchors.fill: parent
                onClicked: showImageGallery = false
            }

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                clip: true

                // Nút đóng
                Rectangle {
                    id: closeButton
                    width: 40
                    height: 40
                    radius: 14
                    color: qgcPal.globalTheme === QGCPalette.Light ? "#d3d3d3" : "#3d3d3d"
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: 12

                   QGCColoredImage {
                        anchors.margins:    parent.height / 4
                        anchors.fill:       parent
                        source:             "/res/XDelete.svg"
                        fillMode:           Image.PreserveAspectFit
                        color:              qgcPal.text
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: showImageGallery = false
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                    }
                }

                Column {
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 24
                    spacing: 12

                    ListView {
                        id: galleryListView
                        orientation: ListView.Horizontal
                        height: Screen.height * 0.6
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.topMargin: Screen.height * 0.125  // Hạ xuống từ trên 80px
                        spacing: 24
                        clip: false  // Cho phép phóng to vượt ra ngoài
                        model: selectedDrone && selectedDrone.gallery ? selectedDrone.gallery : []
                        snapMode: ListView.SnapToItem
                        preferredHighlightBegin: (width - (Screen.width * 0.6)) / 2
                        preferredHighlightEnd: (width - (Screen.width * 0.6)) / 2
                        highlightRangeMode: ListView.StrictlyEnforceRange
                        interactive: true

                        delegate: Item {
                            width: (Screen.width * 0.6)
                            height: 540
                            property real centerPos: galleryListView.contentX + galleryListView.width / 2
                            property real itemCenter: x + width / 2
                            property real dist: Math.abs(itemCenter - centerPos)
                            property real scaleFactor: Math.max(0.8, 1.2 - dist / 400)

                            opacity: dist < 20 ? 1.0 : 0.5

                            Behavior on opacity {
                                NumberAnimation { duration: 150 }
                            }

                            transform: Scale {
                                origin.x: width / 2
                                origin.y: height / 2
                                xScale: scaleFactor
                                yScale: scaleFactor
                            }

                            Rectangle {
                                anchors.fill: parent
                                radius: 12
                                border.color: qgcPal.globalTheme === QGCPalette.Light ? "#ccc" : "#555"
                                color: qgcPal.globalTheme === QGCPalette.Light ? "#ddd": "#333"

                                Image {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    source: modelData
                                    fillMode: Image.PreserveAspectFit
                                }
                            }
                        }
                    }

                }

            }
        }
    }

}
