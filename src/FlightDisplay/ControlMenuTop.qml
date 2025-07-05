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

    property string currentTab: "POWERLINE"

    function switchTab(tabId) {
        currentTab = tabId
        console.log("🔁 Switched to tab:", tabId)
    }

    // Cấu hình tỷ lệ chung để auto scale
    property real buttonWidth: 90
    property real buttonHeight: 22
    property int fontSize: 1

    Column {
        spacing: 6
        anchors.centerIn: parent
        Row {
            spacing: 6

            ItemButton {
                id: btnPOWERLINE
                defaultColor: "transparent"
                activeColor: "#d1222222"
                width: buttonWidth
                height: buttonHeight
                radius: 6
                bold: true
                fontSize: fontSize
                label: "POWERLINE"
                isActive: currentTab === "POWERLINE"
                onClicked: switchTab("POWERLINE")
            }

            ItemButton {
                id: btnCONSTRUCTION
                defaultColor: "transparent"
                activeColor: "#d1222222"
                width: buttonWidth + 20
                height: buttonHeight
                radius: 6
                bold: true
                fontSize: fontSize
                label: "CONSTRUCTION"
                isActive: currentTab === "CONSTRUCTION"
                onClicked: switchTab("CONSTRUCTION")
            }

            ItemButton {
                id: btnTOURISM
                defaultColor: "transparent"
                activeColor: "#d1222222"
                width: buttonWidth - 10
                height: buttonHeight
                radius: 6
                bold: true
                fontSize: fontSize
                label: "TOURISM"
                isActive: currentTab === "TOURISM"
                onClicked: switchTab("TOURISM")
            }
        }
    }
}
