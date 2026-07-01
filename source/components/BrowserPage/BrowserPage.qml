import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import QtWebChannel 1.0

import NavBar 1.0
import CustomWebEngineView 1.0

import WebSearchManager 1.0


Rectangle {
    id: browserPage

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

                url: browserPageWebEngineViewBaseUrl

                webChannel: browserPageWebChannel
                devToolsView: browserPageCustomWebEngineViewDevTools

                SplitView.fillWidth: true
            }

            CustomWebEngineView {
                id: browserPageCustomWebEngineViewDevTools
                visible: false
            }
        }
    }
    
    Connections {
        target: browserPageCustomWebEngineView

        function onLoadingChanged(webEngineLoadingInfo) {
            tabController.setTabIconPath(index, browserPageCustomWebEngineView.icon)
            tabController.setTabTitle(index, browserPageCustomWebEngineView.title)
        }
    }
}
