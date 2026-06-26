import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

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