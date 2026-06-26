import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebEngine 1.10
import QtWebChannel 1.0

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
