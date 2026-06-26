import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import QtWebEngine 1.9
import QtWebChannel 1.0

import FramelessWindow 1.0
import TitleBar 1.0
import TabBar 1.0
import NavBar 1.0
import WebEngineView 1.0

import WebSearchManager 1.0


FramelessWindow {
    id: mainWindow

    ColumnLayout {            
        anchors.fill: parent
        anchors.margins: 1
        spacing: 0

        TitleBar {
            id: titleBar

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop

            TabBar {
                id: tabBar 
                Layout.fillWidth: true
            }
        }

        StackLayout {
            id: stackLayout

            Layout.fillWidth: true
            Layout.fillHeight: true

            currentIndex: tabController.getCurrentIndex

            Repeater {
                model: tabController.getModel

                delegate: Rectangle {
                    id: browserPage

                    Layout.fillWidth: true
                    Layout.fillHeight: true

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

                            WebEngineView {
                                id: browserPageWebEngineView

                                url: webEngineViewUrl

                                webChannel: browserPageWebChannel
                                devToolsView: browserPageWebEngineViewDevTools

                                SplitView.fillWidth: true
                            }

                            WebEngineView {
                                id: browserPageWebEngineViewDevTools
                                visible: false
                            }
                        }
                    }
                }
            }
        }
    }       
    
    Component.onCompleted: {
        framelessWindowController.setWindow(mainWindow)
        framelessWindowController.setTitleBar(titleBar)
    }
}