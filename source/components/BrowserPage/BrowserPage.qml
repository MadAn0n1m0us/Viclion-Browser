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

    property alias browserPage: browserPageLayout.data

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
            id: navBar

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
        }

        SplitView {
            id: browserPageSplitter

            Layout.fillWidth: true
            Layout.fillHeight: true

            CustomWebEngineView {
                id: webEngineView

                url: browserPageUrl

                webChannel: browserPageWebChannel
                devToolsView: webEngineViewDevTools

                SplitView.fillWidth: true
            }

            WebEngineView {
                id: webEngineViewDevTools
                visible: false
            }
        }
    }
    
    Connections {
        target: webEngineView

        function onLoadingChanged(webEngineLoadingInfo) {
            tabController.setTabTitle(index, webEngineView.title)

            navBar.leftSideNavBarLayout.backButton.enabled = webEngineView.canGoBack
            navBar.leftSideNavBarLayout.forwardButton.enabled = webEngineView.canGoForward
        
            switch (webEngineLoadingInfo.status) {

                case WebEngineView.LoadStartedStatus:
                    tabController.setTabIconPath(index, webEngineView.icon != "" ? webEngineView.icon : appIconPath)
        
                    navBar.leftSideNavBarLayout.reloadButton.iconSource = "../../assets/close_icon.svg"
                    navBar.leftSideNavBarLayout.reloadButton.func = function() {
                        webEngineView.stop()
                    }
                    break

                case WebEngineView.LoadStoppedStatus:        
                    navBar.leftSideNavBarLayout.reloadButton.iconSource = "../../assets/reload_icon.png"
                    navBar.leftSideNavBarLayout.reloadButton.func = function() {
                        webEngineView.reload()
                    }
                    break

                case WebEngineView.LoadSucceededStatus:
                    navBar.leftSideNavBarLayout.reloadButton.iconSource = "../../assets/reload_icon.png"
                    navBar.leftSideNavBarLayout.reloadButton.func = function() {
                        webEngineView.reload()
                    }

                    historyController.addToTheHistory(
                        webEngineView.title,
                        webEngineView.url.toString(),
                        new Date().toISOString()
                    )
                    break

                case WebEngineView.LoadFailedStatus:
                    navBar.leftSideNavBarLayout.reloadButton.iconSource = "../../assets/reload_icon.png"
                    navBar.leftSideNavBarLayout.reloadButton.func = function() {
                        webEngineView.reload()
                    }
                    break

            }
        }

        function onUrlChanged() {            
            navBar.addressBar.cursorPosition = 0
        }
    }
}
