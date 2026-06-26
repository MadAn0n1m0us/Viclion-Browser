import QtQuick 2.15
import QtQuick.Controls 2.15


ProgressBar {
    id: progressBar

    property int total
    property int received

    value: total > 0
            ? (received / total) * 100
            : 0
    to: 100
                        
    background: Rectangle {
        id: progressBarBackground

        implicitWidth: parent.width
        implicitHeight: 4

        radius: themeController.getCurrentTheme.qss.progressBar.radius
        color: themeController.getCurrentTheme.qss.progressBar.backgroundColor
    }

    contentItem: Item {
        implicitWidth: parent.width
        implicitHeight: progressBarBackground.height

        Rectangle {
            width: progressBar.visualPosition * parent.width
            height: parent.height

            radius: themeController.getCurrentTheme.qss.progressBar.radius
            color: themeController.getCurrentTheme.qss.progressBar.progressBackgroundColor
        }
    }
}