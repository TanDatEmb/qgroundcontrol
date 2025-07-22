import QtQuick
import QtQuick.Controls
import QGroundControl
import QGroundControl.Controls

Rectangle {
    id: _root
    width: 660
    height: 92
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
            spacing: 8

            Row {
                spacing: 8

                ItemButton {
                    id: fireBtnStart
                    width: 142
                    height: 42
                    radius: 4
                    fontSize: 12
                    label: qsTr("Start Mission")
                    onClicked: sendCustomMavCommand(fireBtnStart, 42000)
                }

                ItemButton {
                    id: fireBtnCoiBao
                    width: 92
                    height: 42
                    radius: 4
                    fontSize: 12
                    label: qsTr("Siren")
                    iconSource: "/icons/campaign_while.svg"
                    onClicked: fireBtnCoiBao.isActive
                        ? sendCustomMavCommand(fireBtnCoiBao, 42009)
                        : sendCustomMavCommand(fireBtnCoiBao, 42001)
                }

                ItemButton {
                    id: fireBtn7
                    width: 42
                    height: 42
                    radius: 4
                    fontSize: 12
                    label: "7"
                    iconSource: "/icons/rocket_while.svg"
                    onClicked: sendCustomMavCommand(fireBtn7, 42007)
                }
            }

            Row {
                spacing: 8

                ItemButton {
                    id: fireBtnBom
                    width: 142
                    height: 42
                    radius: 4
                    fontSize: 12
                    label: qsTr("Drop Water Bombs")
                    onClicked: sendCustomMavCommand(fireBtnBom, 42022)
                }

                Repeater {
                    model: 3
                    delegate: ItemButton {
                        id: fireBtn
                        width: 42
                        height: 42
                        radius: 4
                        fontSize: 12
                        label: (index + 1).toString()
                        iconSource: "/icons/rocket_while.svg"
                        onClicked: sendCustomMavCommand(fireBtn, 42021 + index)
                    }
                }
            }
        }
    }

    // -------- MAPPING --------
    Component {
        id: mappingUI

        Column {
            spacing: 8
            Row {
                spacing: 8
                 ItemButton {
                    id: defineAreaBtn
                    width: 142
                    height: 42
                    radius: 4
                    fontSize: 12
                    label: qsTr("Define Area")
                    // iconSource: "/icons/draw_area.svg"
                    onClicked: sendCustomMavCommand(defineAreaBtn, 32001) // Command giả lập
                }

                ItemButton {
                    id: calcGridBtn
                    width: 142
                    height: 42
                    radius: 4
                    fontSize: 12
                    label: qsTr("Generate Grid")
                    //iconSource: "/icons/grid.svg"
                    onClicked: sendCustomMavCommand(calcGridBtn, 32002)
                }
            }
            Row {
                spacing: 8

                ItemButton {
                    id: startMappingBtn
                    width: 142
                    height: 42
                    radius: 4
                    fontSize: 12
                    label: qsTr("Start Mapping")
                    //iconSource: "/icons/play.svg"
                    onClicked: sendCustomMavCommand(startMappingBtn, 32003)
                }

                ItemButton {
                    id: cancelMissionBtn
                    width: 142
                    height: 42
                    radius: 4
                    fontSize: 12
                    label: qsTr("Cancel Mission")
                    //iconSource: "/icons/stop.svg"
                    onClicked: sendCustomMavCommand(cancelMissionBtn, 32004)
                }

            }
        }
    }
}
