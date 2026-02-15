import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import ".."

Text {
    id: volumeWidget

    property int volumeLevel: 0
    property bool volumeMuted: false
    property string audioSink: "speaker"  // speaker, headphone, hdmi, bluetooth

    property string volumeIcon: {
        if (volumeMuted) return "󰖁"
        if (audioSink === "headphone") return "󰋋" // Added Headphone icon
        if (audioSink === "bluetooth") return "󰂰"
        if (audioSink === "hdmi") return "󰡁"
        
        // Speaker icons based on volume
        if (volumeLevel < 30) return "󰕿" // Added Low volume
        if (volumeLevel < 70) return "󰖀" // Added Medium volume
        return "󰕾" // Added High volume
    }

    text: volumeIcon + " " + volumeLevel + "%"
    color: volumeMuted ? Theme.muted :
           audioSink === "headphone" ? Theme.text :
           audioSink === "bluetooth" ? Theme.Text :
           Theme.text
    font.pixelSize: Theme.fontSize
    font.family: Theme.fontFamily
    font.bold: true

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: volumeControlProc.running = true
    }

    // Volume level and Mute State (PulseAudio pactl)
    Process {
        id: volProc
        // We use 'sh -c' to run both mute and volume checks back-to-back
        command: ["sh", "-c", "pactl get-sink-mute @DEFAULT_SINK@; pactl get-sink-volume @DEFAULT_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                
                // 1. Check for mute state (Output looks like: "Mute: yes" or "Mute: no")
                if (data.includes("Mute: yes")) {
                    volumeWidget.volumeMuted = true
                } else if (data.includes("Mute: no")) {
                    volumeWidget.volumeMuted = false
                }

                // 2. Extract Volume (Output looks like: "... /  50% / ...")
                var match = data.match(/(\d+)%/)
                if (match) {
                    volumeWidget.volumeLevel = parseInt(match[1], 10)
                }
            }
        }
        Component.onCompleted: running = true
    }

    // Audio sink type detection (No changes needed, pactl works here already)
    Process {
        id: sinkProc
        command: ["pactl", "get-default-sink"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var sink = data.toLowerCase()
                if (sink.includes("headphone") || sink.includes("headset")) {
                    volumeWidget.audioSink = "headphone"
                } else if (sink.includes("hdmi") || sink.includes("displayport")) {
                    volumeWidget.audioSink = "hdmi"
                } else if (sink.includes("bluez") || sink.includes("bluetooth")) {
                    volumeWidget.audioSink = "bluetooth"
                } else {
                    volumeWidget.audioSink = "speaker"
                }
            }
        }
        Component.onCompleted: running = true
    }

    // Volume control launcher
    Process {
        id: volumeControlProc
        command: ["pavucontrol"]
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            volProc.running = true
            sinkProc.running = true
        }
    }
}
