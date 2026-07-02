import QtQuick
import QtQuick.Controls

import QtWebEngine 
import QtWebChannel

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
