import QtQuick
import QtQuick.Controls

import QtWebEngine
import QtWebChannel

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "Pont Python -> QML -> HTML"

    WebChannel {
        id: canalWeb
        Component.onCompleted: {
            canalWeb.registerObject("cleHtml", monObjetPython)
        }
    }

    WebEngineView {
        anchors.fill: parent
        webChannel: canalWeb 
        
        // --- MODIFICATION ICI ---
        // Utilisation directe de la variable injectée par Python
        url: urlFichierHtml 
        // -------------------------
    }
}
