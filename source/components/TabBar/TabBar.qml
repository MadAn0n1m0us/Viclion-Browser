import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import utils 1.0
import TabButton 1.0


Rectangle {
    id: tabBar

    height: 36

    color: "transparent"

    default property alias tabBar: tabBarLayout.data

    RowLayout {
        id: tabBarLayout

        anchors.fill: parent
        anchors.leftMargin: 4
        
        spacing: 4

        ListView {
            id: tabList

            width: contentWidth
            height: contentHeight

            orientation: ListView.Horizontal
            interactive: false
            clip: false

            spacing: tabBarLayout.spacing

            model: tabController.getModel

            currentIndex: tabController.getCurrentIndex

            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

            delegate: TabButton {
                id: tabButton

                tabButtonImageSource: iconPath
                tabButtonText: title

                closeTabButton.onClicked: {
                    tabController.closeTab(index)
                }

                onClicked: {
                    tabController.setCurrentIndex(index)
                } 
            }
        }
            
        Button {
            id: addTabButton

            width: 32
            height: 32

            radius: themeController.getCurrentTheme.qss.addTabButton.radius

            buttonImage.source: "./assets/add_tab_icon.png"

            buttonImage.width: 20
            buttonImage.height: 20

            buttonImageColor: themeController.getCurrentTheme.qss.global.fontColor

            backgroundColor: themeController.getCurrentTheme.qss.addTabButton.backgroundColor
            hoverColor: themeController.getCurrentTheme.qss.addTabButton.hoverColor
            clickedColor: themeController.getCurrentTheme.qss.addTabButton.clickedColor

            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

            onClicked: {
                tabController.createTab(appIconPath, "tab", stackLayout.browserPage)
            }
        }
    }
}
