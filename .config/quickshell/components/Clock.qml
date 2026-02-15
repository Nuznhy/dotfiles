import QtQuick
import QtQuick.Layouts
import ".."

Text {
    id: clockText
    text: " " + Qt.formatDateTime(new Date(), "hh:mm:ss - dddd, d MMMM")
    color: Theme.text
    font.pixelSize: Theme.fontSize - 2
    font.family: Theme.fontFamily
    font.bold: true

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clockText.text = " " + Qt.formatDateTime(new Date(), "hh:mm:ss - dddd, d MMMM")
    }
}
