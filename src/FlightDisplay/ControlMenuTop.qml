import QtQuick
import QtQuick.Controls
import QGroundControl
import QGroundControl.Controls

Rectangle {
    id: _root
    width: 200
    height: 24
    color: "transparent"
    // color: "#ff0000"

    visible: QGroundControl.multiVehicleManager.activeVehicle !== null

    property string currentTab: ""
    
    signal tabChanged(string newTab)

    Component.onCompleted: {
        tabChanged(btnDEFAULT.tabId) // Optional: nếu bạn muốn phát ra sự kiện khi load lần đầu
    }

    // Cấu hình tỷ lệ chung để auto scale
    property real buttonWidth: 90
    property real buttonHeight: 22
    property int fontSize: 7

    Column {
        spacing: 6
        anchors.centerIn: parent
        Row {
            spacing: 6

            ItemButton {
                id: btnDEFAULT
                property string tabId: "DEFAULT"
                defaultColor: "transparent"
                activeColor: "#d1222222"
                width: buttonWidth
                height: buttonHeight
                radius: 6
                bold: true
                fontSize: fontSize
                label: qsTr("DEFAULT")
                isActive: currentTab === tabId
                onClicked: tabChanged(tabId)
            }

            ItemButton {
                id: btnFIREFIGHTING
                property string tabId: "FIRE FIGHTING"
                defaultColor: "transparent"
                activeColor: "#d1222222"
                width: buttonWidth + 20
                height: buttonHeight
                radius: 6
                bold: true
                fontSize: fontSize
                label: qsTr("FIRE FIGHTING")
                isActive: currentTab === tabId
                onClicked: tabChanged(tabId)
            }

            ItemButton {
                id: btnBOMBING
                property string tabId: "BOMBING"
                defaultColor: "transparent"
                activeColor: "#d1222222"
                width: buttonWidth - 10
                height: buttonHeight
                radius: 6
                bold: true
                fontSize: fontSize
                label: qsTr("BOMBING")
                isActive: currentTab === tabId
                onClicked: tabChanged(tabId)
            }
        }
    }
}
