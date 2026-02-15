// shell.qml
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "components"

ShellRoot {
    id: root
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: barWindow
            property var modelData
            screen: modelData
            signal closeAllPopups()

            Connections {
                target: Hyprland
                function onRawEvent(event) {
                    if (event.name === "activewindow" || event.name === "activewindowv2") {
                        barWindow.closeAllPopups()
                    }
                }
            }
            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 42
            color: Theme.bg
            margins {
                top: 0
                bottom: 0
                left: 0
                right: 0
            }

            Rectangle {
                anchors.fill: parent
                color: Theme.bg

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    // Left padding
                    Item { width: 24 }

                    // Workspaces
                        WorkspaceBar {
                            Layout.preferredHeight: parent.height
                            Layout.alignment: Qt.AlignLeft
                        }

                    Item {
                        Layout.fillWidth: true
                    }

                    Clock {
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item {
                        Layout.fillWidth: true
                    }


                    VolumeWidget{}
                        Item { width: 24 } 
                }
            }

            MouseArea {
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: (mouse) => {
                    barWindow.closeAllPopups()
                    mouse.accepted = false
                }
            }
        }
    }
}
