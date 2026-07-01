import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import FramelessWindow 1.0
import TitleBar 1.0
import TabBar 1.0
import BrowserPage 1.0


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

                delegate: BrowserPage {
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