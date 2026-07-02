import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Popup {
    id: popup

    padding: 4

    background: Item {

        Rectangle {
            id: backgroundRect

            anchors.fill: parent

            radius: themeController.getCurrentTheme.qss.popup.radius
            color: themeController.getCurrentTheme.qss.popup.backgroundColor

            visible: false
        }

        MultiEffect {
            anchors.fill: backgroundRect

            source: backgroundRect

            shadowEnabled: true
            shadowBlur: 0.8
            shadowOpacity: 0.5
            shadowVerticalOffset: 4
            shadowHorizontalOffset: 0

            shadowColor: "#80000000"
        }

        Rectangle {
            anchors.fill: parent

            radius: themeController.getCurrentTheme.qss.popup.radius
            color: themeController.getCurrentTheme.qss.popup.backgroundColor
        }
    }
}