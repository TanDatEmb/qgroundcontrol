import QtQuick
import QtQuick.Controls
import QGroundControl
import QGroundControl.Controls

Rectangle {
    id: _root
    width: 360
    height: 80
    color: "transparent"
    visible: QGroundControl.multiVehicleManager.activeVehicle !== null

    property string currentTab: ""

    function sendCustomMavCommand(btn_id, mavCmdId, param1 = 1) {
        let vehicle = QGroundControl.multiVehicleManager.activeVehicle
        if (vehicle) {
            btn_id.isActive = !btn_id.isActive
            // vehicle.sendCommand(
            //     vehicle.id,
            //     mavCmdId,
            //     true,
            //     param1, 0, 0, 0, 0, 0, 0
            // )
            console.log("📡 Send MAV_CMD " + mavCmdId)
        } else {
            console.warn("🚫 error")
        }
    }

    Loader {
        id: tabContentLoader
        anchors.centerIn: parent
        sourceComponent: {
            if (currentTab === "FIRE FIGHTING"){ _root.height = 80; return fireFightingUI;}
            else if (currentTab === "MAPPING") {_root.height = 42; return mappingUI; }
            else return null
        }
    }

    // -------- FIRE FIGHTING --------
    Component {
        id: fireFightingUI

        Column {
            spacing: 6

            Row {
                spacing: 6

                ItemButton {
                    id: fireBtnStart
                    width: 108
                    height: 28
                    radius: 4
                    fontSize: 10
                    label: qsTr("Start Mission")
                    onClicked: sendCustomMavCommand(fireBtnStart, 30000)
                }

                ItemButton {
                    id: fireBtnCoiBao
                    width: 70
                    height: 28
                    radius: 4
                    fontSize: 10
                    label: qsTr("Siren")
                    iconSource: "/icons/campaign_while.svg"
                    onClicked: fireBtnCoiBao.isActive
                        ? sendCustomMavCommand(fireBtnCoiBao, 30009)
                        : sendCustomMavCommand(fireBtnCoiBao, 30001)
                }

                ItemButton {
                    id: fireBtn7
                    width: 32
                    height: 28
                    radius: 4
                    fontSize: 10
                    label: "7"
                    iconSource: "/icons/rocket_while.svg"
                    onClicked: sendCustomMavCommand(fireBtn7, 30007)
                }
            }

            Row {
                spacing: 6

                ItemButton {
                    id: fireBtnBom
                    width: 108
                    height: 28
                    radius: 4
                    fontSize: 10
                    label: qsTr("Drop Water Bombs")
                    onClicked: sendCustomMavCommand(fireBtnBom, 30022)
                }

                Repeater {
                    model: 3
                    delegate: ItemButton {
                        id: fireBtn
                        width: 32
                        height: 28
                        radius: 4
                        fontSize: 10
                        label: (index + 1).toString()
                        iconSource: "/icons/rocket_while.svg"
                        onClicked: sendCustomMavCommand(fireBtn, 30021 + index)
                    }
                }
            }
        }
    }

    // -------- BOMBING --------
    Component {
        id: mappingUI

        Column {
            spacing: 6

            Row {
                spacing: 6

                ItemButton {
                    id: defineAreaBtn
                    width: 56
                    height: 28
                    radius: 4
                    fontSize: 10
                    label: qsTr("Define Area")
                    // iconSource: "/icons/draw_area.svg"
                    onClicked: sendCustomMavCommand(defineAreaBtn, 32001) // Command giả lập
                }

                ItemButton {
                    id: calcGridBtn
                    width: 56
                    height: 28
                    radius: 4
                    fontSize: 10
                    label: qsTr("Generate Grid")
                    //iconSource: "/icons/grid.svg"
                    onClicked: sendCustomMavCommand(calcGridBtn, 32002)
                }

                ItemButton {
                    id: startMappingBtn
                    width: 56
                    height: 28
                    radius: 4
                    fontSize: 10
                    label: qsTr("Start Mapping")
                    //iconSource: "/icons/play.svg"
                    onClicked: sendCustomMavCommand(startMappingBtn, 32003)
                }

                ItemButton {
                    id: cancelMissionBtn
                    width: 56
                    height: 28
                    radius: 4
                    fontSize: 10
                    label: qsTr("Cancel Mission")
                    //iconSource: "/icons/stop.svg"
                    onClicked: sendCustomMavCommand(cancelMissionBtn, 32004)
                }
            }
        }
    }

}
