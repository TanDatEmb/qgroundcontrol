import QtQuick
import QtQuick.Controls
import QGroundControl
import QGroundControl.Controls

Rectangle {
    id: _root
    width: 600
    height: 30
    color: "transparent"
    // color: "#ff0000"

    visible: QGroundControl.multiVehicleManager.activeVehicle !== null

    property string currentTab: ""
    
    signal tabChanged(string newTab)

    Component.onCompleted: {
        tabChanged(btnDEFAULT.tabId) // Optional: nếu bạn muốn phát ra sự kiện khi load lần đầu
    }

    // Cấu hình tỷ lệ chung để auto scale
    property real buttonWidth: 120
    property real buttonHeight: 30
    property int fontSize: 14

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
                width: _root.buttonWidth
                height: _root.buttonHeight
                radius: 6
                bold: true
                fontSize: _root.fontSize
                label: qsTr("DEFAULT")
                isActive: currentTab === tabId
                onClicked: tabChanged(tabId)
            }

            ItemButton {
                id: btnFIREFIGHTING
                property string tabId: "FIRE FIGHTING"
                defaultColor: "transparent"
                activeColor: "#d1222222"
                width: _root.buttonWidth + 20
                height: _root.buttonHeight
                radius: 6
                bold: true
                fontSize: _root.fontSize
                label: qsTr("FIRE FIGHTING")
                isActive: currentTab === tabId
                onClicked: tabChanged(tabId)
            }

            ItemButton {
                id: btnMAPPING
                property string tabId: "MAPPING"
                defaultColor: "transparent"
                activeColor: "#d1222222"
                width: _root.buttonWidth - 10
                height: _root.buttonHeight
                radius: 6
                bold: true
                fontSize: _root.fontSize
                label: qsTr("MAPPING")
                isActive: currentTab === tabId
                onClicked: tabChanged(tabId)
            }
        }
    }
}
