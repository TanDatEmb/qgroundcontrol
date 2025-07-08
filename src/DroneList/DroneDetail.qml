import QtQuick 
import QtQuick.Controls 
import QtQuick.Layouts 
import QtQuick3D
import Qt5Compat.GraphicalEffects


Rectangle {
    id: detailPage
    // anchors.fill: parent
    // z: 0

    property var uavData
    property var onBack: function() {}
    property real dragX: 0
    property real dragY: 0

    // Nút quay lại
    Button {
        text: "← Back"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: onBack()
    }

    // Tên & mã code
    Column {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4
        Text {
            text: uavData.name
            font.bold: true
            font.pointSize: 20
        }
        Text {
            text: uavData.code
            font.pointSize: 14
        }
    }

    // Ảnh UAV
    Image {
        source: uavData.image
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 24
        width: 200
        height: 160
        fillMode: Image.PreserveAspectFit
    }

    // Mô tả
    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 180
        anchors.rightMargin: 24
        width: 200
        height: 150
        radius: 16
        color: "#eeeeee"
        Text {
            anchors.centerIn: parent
            width: parent.width * 0.9
            wrapMode: Text.WordWrap
            text: uavData.description ?? "No description"
        }
    }

    // Thông số kỹ thuật
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 24
        anchors.topMargin: 80
        width: 220
        height: 300
        radius: 16
        color: "#f5f5f5"
        ScrollView {
            anchors.fill: parent
            Column {
                spacing: 6
                Repeater {
                    model: Object.keys(uavData).filter(k => !["name", "code", "image", "description", "link"].includes(k))
                    delegate: Text {
                        text: `${modelData}: ${uavData[modelData]}`
                        font.pointSize: 12
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        width: 220
        height: 220
        radius: 16
        color: "#1aeeb2"
        
        // Placeholder for 3D model, replace with actual model loading logic
        Text {
            anchors.centerIn: parent
            text: "3D Model Placeholder"
            font.pointSize: 14
            color: "#888888"
        }
    }

    // Button liên hệ & xác nhận
    Row {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        spacing: 12
        anchors.bottomMargin: 16
        anchors.rightMargin: 16
        Button {
            text: "Xác nhận"
            onClicked: console.log("Xác nhận UAV:", uavData.name)
        }
    }
}
