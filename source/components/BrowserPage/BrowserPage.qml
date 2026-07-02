import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import QtWebEngine
import QtWebChannel

import NavBar 1.0
import CustomWebEngineView 1.0

import WebSearchManager 1.0


Rectangle {
    id: browserPage

    property string browserPageUrl

    WebSearchController {
        id: addressBarWebSearchController
    }

    WebSearchController {
        id: webSearchController
    }

    WebChannel {
        id: browserPageWebChannel

        Component.onCompleted: {
            browserPageWebChannel.registerObject("backend", backend)
            browserPageWebChannel.registerObject("webSearchController", webSearchController)
        }
    }

    ColumnLayout {
        id: browserPageLayout
        anchors.fill: parent
        spacing: 0

        NavBar {
            id: browserPageNavBar

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
        }

        SplitView {
            id: browserPageSplitter

            Layout.fillWidth: true
            Layout.fillHeight: true

            CustomWebEngineView {
                id: browserPageCustomWebEngineView

                url: browserPageUrl

                webChannel: browserPageWebChannel
                devToolsView: browserPageCustomWebEngineViewDevTools

                SplitView.fillWidth: true
            }

            WebEngineView {
                id: browserPageCustomWebEngineViewDevTools
                visible: false
            }
        }
    }
    
    Connections {
        target: browserPageCustomWebEngineView

        function onLoadingChanged(webEngineLoadingInfo) {
            if (webEngineLoadingInfo.status === WebEngineView.LoadSucceededStatus) {
                tabController.setTabIconPath(index, browserPageCustomWebEngineView.icon)
                tabController.setTabTitle(index, browserPageCustomWebEngineView.title)
            }
        }
    }
}
