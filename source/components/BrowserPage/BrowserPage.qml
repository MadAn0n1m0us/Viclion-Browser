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
            tabController.setTabIconPath(index, browserPageCustomWebEngineView.icon)
            tabController.setTabTitle(index, browserPageCustomWebEngineView.title)

            browserPageNavBar.leftSideNavBarLayout.backButton.enabled = browserPageCustomWebEngineView.canGoBack
            browserPageNavBar.leftSideNavBarLayout.forwardButton.enabled = browserPageCustomWebEngineView.canGoForward
        
            switch (webEngineLoadingInfo.status) {

                case WebEngineView.LoadStartedStatus:
                    browserPageNavBar.leftSideNavBarLayout.reloadButton.iconSource = "../../assets/close_icon.svg"
                    browserPageNavBar.leftSideNavBarLayout.reloadButton.func = function() {
                        browserPageCustomWebEngineView.stop()
                    }
                    break

                case WebEngineView.LoadSucceededStatus:
                    browserPageNavBar.leftSideNavBarLayout.reloadButton.iconSource = "../../assets/reload_icon.png"
                    browserPageNavBar.leftSideNavBarLayout.reloadButton.func = function() {
                        browserPageCustomWebEngineView.reload()
                    }

                    historyController.addToTheHistory(
                        browserPageCustomWebEngineView.title,
                        browserPageCustomWebEngineView.url.toString(),
                        new Date().toISOString()
                    )
                    break

                case WebEngineView.LoadFailedStatus:
                    browserPageNavBar.leftSideNavBarLayout.reloadButton.iconSource = "../../assets/reload_icon.png"
                    browserPageNavBar.leftSideNavBarLayout.reloadButton.func = function() {
                        browserPageCustomWebEngineView.reload()
                    }
                    break

            }
        }

        function onUrlChanged() {            
            browserPageNavBar.addressBar.cursorPosition = 0
        }
    }
}
