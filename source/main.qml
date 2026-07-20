import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import FramelessWindow 1.0
import TitleBar 1.0
import TabBar 1.0
import BrowserPage 1.0

import FramelessWindowManager 1.0


FramelessWindow {
    id: mainWindow

    FramelessWindowController {
        id: framelessWindowController
    }

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
                // Layout.alignment: Qt.AlignVCenter
            }
        }

        StackLayout {
            id: stackLayout

            Layout.fillWidth: true
            Layout.fillHeight: true

            currentIndex: tabController.getCurrentIndex

            Repeater {
                model: tabController.getModel

                delegate: BrowserPage {
                    id: browserPage

                    browserPageUrl: url

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }       
    
    Component.onCompleted: {
        framelessWindowController.setWindow(mainWindow)
        framelessWindowController.setTitleBar(titleBar)
    }
}