import QtQuick
import QtQuick.Controls
import QGroundControl
import QGroundControl.Controls

Rectangle {
    // dev tiếp cái này
    id: _root
    width: 360
    height: 80
    color: "transparent"
    // color:"red"
    visible: QGroundControl.multiVehicleManager.activeVehicle !== null

    function sendCustomMavCommand(btn_id, mavCmdId, param1 = 1) {
        let vehicle = QGroundControl.multiVehicleManager.activeVehicle
        if (vehicle) {
            btn_id.isActive = !btn_id.isActive
            vehicle.sendCommand(
                vehicle.id,
                mavCmdId,
                true,
                param1, 0, 0, 0, 0, 0, 0
            )
            console.log("📡 Send MAV_CMD " + mavCmdId)
        } else {
            console.warn("🚫 error")
        }
    }

    Column {
        spacing: 6
        anchors.centerIn: parent

        Row {
            spacing: 6

            ItemButton {
                id: btnStartMission
                width: 110
                height: 28
                radius: 4
                fontSize: 10
                label: "Start Mission"
                onClicked: sendCustomMavCommand(btnStartMission, 30000)
            }

            ItemButton {
                id: btnCoiBao
                width: 80
                height: 28
                radius: 4
                fontSize: 10
                label: "Còi báo"
                iconSource: "/icons/campaign_while.svg"
                onClicked: btnCoiBao.isActive ? sendCustomMavCommand(btnCoiBao, 30009) : sendCustomMavCommand(btnCoiBao, 30001)
            }

            ItemButton {
                id: btn7
                width: 32
                height: 28
                radius: 4
                fontSize: 10
                label: "7"
                iconSource: "/icons/rocket_while.svg"
                onClicked: sendCustomMavCommand(btn7, 30007)
            }
        }

        Row {
            spacing: 6

            ItemButton {
                id: btn1
                width: 32
                height: 28
                radius: 4
                fontSize: 10
                label: "1"
                iconSource: "/icons/rocket_while.svg"
                onClicked: sendCustomMavCommand(btn1, 30001)
            }

            ItemButton {
                id: btn2
                width: 32
                height: 28
                radius: 4
                fontSize: 10
                label: "2"
                iconSource: "/icons/rocket_while.svg"
                onClicked: sendCustomMavCommand(btn2, 30002)
            }

            ItemButton {
                id: btn3
                width: 32
                height: 28
                radius: 4
                fontSize: 10
                label: "3"
                iconSource: "/icons/rocket_while.svg"
                onClicked: sendCustomMavCommand(btn3, 30003)
            }

            ItemButton {
                id: btn4
                width: 32
                height: 28
                radius: 4
                fontSize: 10
                label: "4"
                iconSource: "/icons/rocket_while.svg"
                onClicked: sendCustomMavCommand(btn4, 30004)
            }

            ItemButton {
                id: btn5
                width: 32
                height: 28
                radius: 4
                fontSize: 10
                label: "5"
                iconSource: "/icons/rocket_while.svg"
                onClicked: sendCustomMavCommand(btn5, 30005)
            }

            ItemButton {
                id: btn6
                width: 32
                height: 28
                radius: 4
                fontSize: 10
                label: "6"
                iconSource: "/icons/rocket_while.svg"
                onClicked: sendCustomMavCommand(btn6, 30006)
            }
        }
    }
}
