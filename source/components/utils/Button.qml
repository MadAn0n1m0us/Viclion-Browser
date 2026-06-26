import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

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
        anchors.margins: buttonText.visible && buttonImage.visible ? 10: 0

        Item {
            width: buttonImage.width
            height: buttonImage.height

            Layout.alignment: buttonText.visible ? Qt.AlignVCenter | Qt.AlignLeft: Qt.AlignCenter

            Image {
                id: buttonImage
                visible: source != ""
                fillMode: Image.PreserveAspectFit
            }

            ColorOverlay {
                width: buttonImage.width
                height: buttonImage.height
                
                source: buttonImage
                color: buttonImageColor
                visible: buttonImage.visible
            }
        }

        Text {
            id: buttonText
            visible: text != ""
            Layout.alignment: buttonImage.visible ? Qt.AlignVCenter | Qt.AlignLeft: Qt.AlignCenter
        }

        Item {
            Layout.fillWidth: buttonImage.visible && buttonText.visible ? true: false
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