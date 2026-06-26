import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import utils 1.0


Rectangle {
    height: 40

    color: themeController.getCurrentTheme.qss.titleBar.backgroundColor

    default property alias titleBarLayout: titleBarLayout.data

    function updateMaximizeOrRestoreButtonIcon(state) {
        if (state === 0) {
            maximizeOrRestoreButton.buttonImage.source =
                "./assets/maximize_window_icon.png"
        } else if (state === 2) {
            maximizeOrRestoreButton.buttonImage.source =
                "./assets/restore_window_icon.png"
        }
    }

    RowLayout {
        id: titleBarLayout
        anchors.fill: parent
        spacing: 0

        layoutDirection: Qt.RightToLeft

        Button {
            id: closeButton

            width: 48
            height: 40

            buttonImage.source: "./assets/close_window_icon.png"

            buttonImage.width: 16
            buttonImage.height: 16

            buttonImageColor: themeController.getCurrentTheme.qss.global.fontColor

            backgroundColor: themeController.getCurrentTheme.qss.titleBarButton.backgroundColor
            hoverColor: "red"
            clickedColor: "darkred"

            onClicked: {
                framelessWindowController.closeWindow()
            }
        }

        Button {
            id: maximizeOrRestoreButton

            width: 48
            height: 40

            buttonImage.width: 14
            buttonImage.height: 14

            buttonImageColor: themeController.getCurrentTheme.qss.global.fontColor

            buttonText.visible: false

            backgroundColor: themeController.getCurrentTheme.qss.titleBarButton.backgroundColor
            hoverColor: themeController.getCurrentTheme.qss.titleBarButton.hoverColor
            clickedColor: themeController.getCurrentTheme.qss.titleBarButton.clickedColor

            onClicked: {
                framelessWindowController.toggleMaximizeRestore()
            }
        }

        Button {
            id: minimizeButton

            width: 48
            height: 40

            buttonImage.source: "./assets/minimize_window_icon.png"

            buttonImage.width: 18
            buttonImage.height: 13

            buttonImageColor: themeController.getCurrentTheme.qss.global.fontColor

            backgroundColor: themeController.getCurrentTheme.qss.titleBarButton.backgroundColor
            hoverColor: themeController.getCurrentTheme.qss.titleBarButton.hoverColor
            clickedColor: themeController.getCurrentTheme.qss.titleBarButton.clickedColor

            onClicked: {
                framelessWindowController.minimizeWindow()
            }
        }
    }

    Component.onCompleted: {
        updateMaximizeOrRestoreButtonIcon(framelessWindowController.getWindowState())
    }

    Connections {
        target: framelessWindowController

        function onFramelessWindowStateChanged(state) {
            updateMaximizeOrRestoreButtonIcon(state)
        }
    }
}
