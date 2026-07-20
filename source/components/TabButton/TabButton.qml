import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

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

    width: 200
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

    RowLayout {
        id: tabButtonLayout

        anchors.fill: parent
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 4

        spacing: 4

        Image {
            id: image

            source: tabButtonImageSource

            width: 18
            height: 18

            sourceSize: Qt.size(width, height)
        }

        Text {
            id: tabButtonLabel

            clip: true
            elide: Text.ElideRight

            text: tabButtonText

            font.pointSize: 10
            color: themeController.getCurrentTheme.qss.global.fontColor

            Layout.fillWidth: true

            Layout.alignment: Qt.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        Item {
            Layout.fillWidth: true
        }

        Button {
            id: closeTabButton

            width: 20
            height: 20

            buttonImage.source: "../../assets/close_tab_icon.svg"

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
