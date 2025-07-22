import QtQuick
import QtQuick.Controls

import QGroundControl.ScreenTools
import QGroundControl.Palette

Rectangle {
    id: _root
    width: 130
    height: 130
    radius: width / 2
    color: qgcPal.windowShade

    signal accept

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    // Vòng nền trắng nở ra bên dưới
    Rectangle {
        id: backgroundCircle
        property real bgCircleSize: 64  // Giá trị mặc định rõ ràng

        width: bgCircleSize
        height: bgCircleSize
        radius: width / 2
        color: "#229cff"
        anchors.centerIn: parent
        opacity: 0.3
        z: 0

        // Animation KHÔNG khởi động tự động, chỉ kích hoạt khi nhấn giữ
        SequentialAnimation on bgCircleSize {
            id: growAnimation
            running: false
            NumberAnimation { from: 64; to: 130; duration: 1000 }
            ScriptAction {
                script: {
                    if (holdCircle.isHolding) {
                        _root.accept()
                        shrinkAnimation.start()
                    }
                }
            }
        }

        NumberAnimation on bgCircleSize {
            id: shrinkAnimation
            to: 64
            duration: 300
        }
    }


    // Nút hình tròn ở giữa (giữ cố định)
    Rectangle {
        id: holdCircle
        width: 64
        height: 64
        border.width: 2
        border.color: "#9d4e4e4e"
        radius: width / 2
        color: qgcPal.primaryButton
        anchors.centerIn: parent
        z: 1

        property bool isHolding: false

        QGCColoredImage {
            anchors.centerIn: parent
            width: parent.width * 0.5
            height: parent.height * 0.5
            source: "/res/fingerprint.svg"
            color: "#fff"//qgcPal.buttonText
        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                holdCircle.isHolding = true
                growAnimation.start()
            }
            onReleased: {
                if (!growAnimation.running && backgroundCircle.bgCircleSize >= 130) {
                    _root.accept()
                }
                reset()
            }
            onCanceled: reset()

            function reset() {
                holdCircle.isHolding = false
                growAnimation.stop()
                shrinkAnimation.start()
            }
        }
    }
}
