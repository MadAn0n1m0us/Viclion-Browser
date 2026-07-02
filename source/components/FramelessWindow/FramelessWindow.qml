import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls

Window {
    id: framelessWindow

    width: 1000
    height: 600

    minimumHeight: 40

    visible: true
    flags: Qt.Window | Qt.FramelessWindowHint

    default property alias framelessWindowContainer: framelessWindowContainer.data

    Rectangle {
        id: framelessWindowContainer

        anchors.fill: parent

        radius: 0

        color: themeController.getCurrentTheme.qss.framelessWindow.backgroundColor

        border.width: themeController.getCurrentTheme.qss.framelessWindow.border.width
        border.color: themeController.getCurrentTheme.qss.framelessWindow.border.color
    }
}