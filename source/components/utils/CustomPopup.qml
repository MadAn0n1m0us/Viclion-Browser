import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Popup {
    id: popup

    padding: 4

    background: Item {

        DropShadow {
            anchors.fill: backgroundRect

            source: backgroundRect

            horizontalOffset: 0
            verticalOffset: 4

            radius: 12
            samples: 25

            color: "#80000000"
        }

        Rectangle {
            id: backgroundRect

            anchors.fill: parent

            radius: themeController.getCurrentTheme.qss.popup.radius
            color: themeController.getCurrentTheme.qss.popup.backgroundColor
        }
    }
}