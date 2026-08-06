import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

Rectangle {
    id: button

    property bool hovered: false
    property bool pressed: false

    property alias buttonImage: buttonImage
    property alias buttonText: buttonText

    property color buttonImageColor

    property color backgroundColor
    property color hoverColor
    property color clickedColor

    signal clicked()

    color: enabled
       ? (pressed
            ? clickedColor
            : hovered
                ? hoverColor
                : backgroundColor)
            : backgroundColor

    opacity: enabled ? 1.0 : 0.4

    Behavior on color {
        ColorAnimation { 
            duration: 180
        }
    }

    default property alias button: buttonLayout.data

    Row {
        id: buttonLayout

        anchors.horizontalCenter: buttonImage.source && buttonText.visible ? undefined : parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        anchors.left: buttonImage.source && buttonText.visible ? parent.left : undefined
        anchors.leftMargin: buttonImage.source && buttonText.visible ? 4: 0
        
        spacing: 4

        Item {
            width: buttonImage.width
            height: buttonImage.height

            Image {
                id: buttonImage
                visible: false
                fillMode: Image.PreserveAspectFit
            }

            MultiEffect {
                anchors.fill: buttonImage
                source: buttonImage

                colorizationColor: buttonImageColor 
                colorization: 1.0

                visible: buttonImage.source !== false
                brightness: 1.0
            }
        }

        Text {
            id: buttonText
            visible: text != false
        }
    }

    HoverHandler {
        onHoveredChanged: button.hovered = hovered
    }

    TapHandler {
        id: tapHandler
        onPressedChanged: button.pressed = pressed
        onTapped: {
            button.clicked()
        }
    }
}