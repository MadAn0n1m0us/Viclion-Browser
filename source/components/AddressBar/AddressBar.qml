import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15


TextField {
    id: addressBar

    property bool isFocus: false

    height: 32
    font.pointSize: themeController.getCurrentTheme.qss.global.fontSize

    placeholderText: "Entrer URL"
    placeholderTextColor: themeController.getCurrentTheme.qss.global.fontColor
    color: themeController.getCurrentTheme.qss.global.fontColor

    focus: isFocus
    selectByMouse: true

    background: Rectangle { 
        id: addressBarBackground
        
        implicitHeight: 32

        color: themeController.getCurrentTheme.qss.addressBar.backgroundColor

        radius: themeController.getCurrentTheme.qss.addressBar.radius

        border.width: themeController.getCurrentTheme.qss.addressBar.border.width
        border.color: addressBar.activeFocus ? themeController.getCurrentTheme.qss.addressBar.border.focusColor
                        : "transparent"

        anchors.verticalCenter: parent.verticalCenter
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            isFocus = true
        } else {
            isFocus = false
        }
    }
}