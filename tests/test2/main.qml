import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebEngine 1.10
import QtWebChannel 1.0

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "Pont Python -> QML -> HTML"

    header: TabBar {
        id: bar
        width: parent.width

        Repeater {
            model: ["First", "Second", "Third", "Fourth", "Fifth"]

            TabButton {
                text: modelData
                width: Math.max(100, bar.width / 5)
            }
        }
    }
}
