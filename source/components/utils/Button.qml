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

    RowLayout {
        id: buttonLayout

        anchors.fill: parent
        anchors.margins: buttonText.visible && buttonImage.visible ? 4: 0
        
        spacing: 0

        Item {
            width: buttonImage.width
            height: buttonImage.height

            Layout.alignment: buttonText.visible ? Qt.AlignVCenter | Qt.AlignLeft: Qt.AlignCenter

            Image {
                id: buttonImage
                visible: false
                fillMode: Image.PreserveAspectFit
            }

            MultiEffect {
                anchors.fill: buttonImage

                source: buttonImage
                
                colorization: 1.0
                colorizationColor: buttonImageColor

                visible: buttonImage.source !== false
            }
        }

        Text {
            id: buttonText
            visible: text != ""
            Layout.alignment: buttonImage.visible ? Qt.AlignVCenter | Qt.AlignLeft: Qt.AlignCenter
        }
    }

    HoverHandler {
        onHoveredChanged: button.hovered = hovered
    }

    TapHandler {
        onPressedChanged: button.pressed = pressed
        onTapped: {
            button.clicked()
        }
    }
}