import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

import utils 1.0


Rectangle {
    id: tabButton

    property color backgroundColor: themeController.getCurrentTheme.qss.tabButton.backgroundColor
    property color hoverColor: themeController.getCurrentTheme.qss.tabButton.hoverColor
    property color clickedColor: themeController.getCurrentTheme.qss.tabButton.clickedColor

    property string tabButtonImageSource
    property string tabButtonText
    property alias closeTabButton: closeTabButton

    property bool isCurrent: ListView.isCurrentItem

    property bool hovered: false
    property bool pressed: false

    default property alias tabButton: tabButtonLayout.data

    width: 180
    height: 32

    opacity: isCurrent
         ? 0
         : 1

    scale: 0.9

    radius: themeController.getCurrentTheme.qss.tabButton.radius

    signal clicked()

    color: isCurrent
            ? clickedColor    
            :pressed
                ? clickedColor
                : hovered
                    ? hoverColor
                    : backgroundColor

    Behavior on color {
        ColorAnimation {
            duration: 120
        }
    }

    Behavior on opacity {
        NumberAnimation { 
            duration: 120 
        }
    }

    Behavior on scale {
        NumberAnimation { 
            duration: 120 
        }
    }

    anchors.verticalCenter: parent.verticalCenter

    RowLayout {
        id: tabButtonLayout

        anchors.fill: parent
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 4

        spacing: 0

        Item {
            id: imageItem

            width: 18
            height: 18

            Layout.alignment: Qt.AlignLeft

            Image {
                id: image

                source: tabButtonImageSource

                width: imageItem.width
                height: imageItem.height

                sourceSize.width: image.width
                sourceSize.height: image.height

                fillMode: Image.PreserveAspectFit
            }

            ColorOverlay {
                anchors.fill: image
                source: image
                color: themeController.getCurrentTheme.qss.global.fontColor
            }   
        }

        Item {
            width: 4
        }

        Label {
            id: tabButtonLabel

            text: tabButtonText

            font.pointSize: 12
            color: themeController.getCurrentTheme.qss.global.fontColor

            Layout.alignment: Qt.AlignLeft 
        }

        Item {
            Layout.fillWidth: true
        }

        Button {
            id: closeTabButton

            width: 20
            height: 20

            buttonImage.source: "./assets/close_tab_icon.svg"

            buttonImage.width: 12
            buttonImage.height: buttonImage.width

            buttonImage.smooth: true
            buttonImage.mipmap: true

            radius: themeController.getCurrentTheme.qss.closeTabButton.radius

            buttonImageColor: themeController.getCurrentTheme.qss.global.fontColor

            backgroundColor: themeController.getCurrentTheme.qss.closeTabButton.backgroundColor
            hoverColor: themeController.getCurrentTheme.qss.closeTabButton.hoverColor
            clickedColor: themeController.getCurrentTheme.qss.closeTabButton.clickedColor

            Layout.alignment: Qt.AlignRight
        } 
    }

    HoverHandler {
        onHoveredChanged: tabButton.hovered = hovered
    }

    TapHandler {
        onPressedChanged: tabButton.pressed = pressed
        onTapped: {
            tabButton.clicked()
        }
    }

    Component.onCompleted: {
        opacity = 1
        scale = 1
    }
}
