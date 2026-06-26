import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

import QtWebEngine 1.9

import utils 1.0
import AddressBar 1.0


Rectangle {
    id: navBar

    height: 40

    color: themeController.getCurrentTheme.qss.navBar.backgroundColor
    
    default property alias navBar: navBarLayout.data

    Component {
        id: navButtonComponent

        Button {
            property string iconSource: ""
            property var func: None

            width: 32
            height: 32

            radius: themeController.getCurrentTheme.qss.navButton.radius

            buttonImage.source: iconSource

            buttonImage.width: 20
            buttonImage.height: 20

            buttonImageColor: themeController.getCurrentTheme.qss.global.fontColor

            backgroundColor: themeController.getCurrentTheme.qss.navButton.backgroundColor
            hoverColor: themeController.getCurrentTheme.qss.navButton.hoverColor
            clickedColor: themeController.getCurrentTheme.qss.navButton.clickedColor

            Layout.alignment: Qt.AlignVCenter

            onClicked: {
                if (func) {
                    func()
                }
            }
        }
    }

    Component {
        id: menuButtonComponent

        Button {
            property string iconSource: ""
            property string text: ""
            property var func: None

            height: 40

            buttonImage.source: iconSource

            buttonImage.width: 20
            buttonImage.height: 20

            buttonImageColor: themeController.getCurrentTheme.qss.global.fontColor

            buttonText.text: text
            buttonText.color: themeController.getCurrentTheme.qss.global.fontColor

            backgroundColor: themeController.getCurrentTheme.qss.popupButton.backgroundColor
            hoverColor: themeController.getCurrentTheme.qss.popupButton.hoverColor
            clickedColor: themeController.getCurrentTheme.qss.popupButton.clickedColor

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop

            onClicked: {
                if (func) {
                    func()
                }
            }
        }
    }

    function createNavButton(args) {
        var navBarButton = navButtonComponent.createObject(
            args.layout,
            {
                "iconSource": args.iconSource,
                "func": args.func
            }
        )

        return navBarButton
    }

    function createMenuButton(args) {
        var menuButton = menuButtonComponent.createObject(
            args.layout,
            {
                "iconSource": args.iconSource,
                "text": args.text,
                "func": args.func
            }
        )

        return menuButton
    }

    RowLayout {
        id: navBarLayout

        anchors.fill: parent
        anchors.verticalCenter: parent.verticalCenter  
        anchors.margins: 4

        spacing: 80

        RowLayout {
            id: leftSideNavBarLayout

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft

            property var backButton: createNavButton({
                "layout": leftSideNavBarLayout,
                "iconSource": "./assets/back_icon.png",
                "func": function() {
                    browserPageWebEngineView.goBack()
                }
            })

            property var forwardButton: createNavButton({
                "layout": leftSideNavBarLayout,
                "iconSource": "./assets/forward_icon.png",
                "func": function() {
                    browserPageWebEngineView.goForward()
                }
            })

            property var reloadButton: createNavButton({
                "layout": leftSideNavBarLayout,
                "iconSource": "",
                "func": function() {
                    browserPageWebEngineView.reload()
                }
            })

            property var homeButton: createNavButton({
                "layout": leftSideNavBarLayout,
                "iconSource": "./assets/home_icon.png",
                "func": function() {
                    console.log("hello world")
                }
            })
        }

        RowLayout {
            id: centerSideNavBarLayout

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter

            AddressBar {
                id: addressBar
                text: browserPageWebEngineView.url.toString()
                Layout.fillWidth: true

                onTextChanged: {
                    debounceTimer.restart()
                }

                onAccepted: {
                    backend.setWebEngineViewUrl(addressBar.text)
                    addressBar.isFocus = false
                    suggestionBoxPopup.close()
                }
            }

            property var starButton: createNavButton({
                "layout": centerSideNavBarLayout,
                "iconSource": "./assets/empty_star_icon.png",
                "func": function() {
                    console.log("hello world")
                }
            })
        }

        RowLayout {
            id: rightSideNavBarLayout

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight

            property var downloadButton: createNavButton({
                "layout": rightSideNavBarLayout,
                "iconSource": "./assets/download_icon.png",
                "func": function() {
                    downloadPopup.open()
                }
            })

            property var userButton: createNavButton({
                "layout": rightSideNavBarLayout,
                "iconSource": "./assets/user_icon.png",
                "func": function() {
                    console.log("hello world")
                }
            })

            property var extensionButton: createNavButton({
                "layout": rightSideNavBarLayout,
                "iconSource": "./assets/extension_icon.png",
                "func": function() {
                    console.log("hello world")
                }
            })

            property var menuButton: createNavButton({
                "layout": rightSideNavBarLayout,
                "iconSource": "./assets/menu_icon.png",
                "func": function() {
                    menuPopup.open()
                }
            })
        }
    }

    Component.onCompleted: {
        leftSideNavBarLayout.homeButton.visible = false
        rightSideNavBarLayout.downloadButton.visible = false
    }
      
    /* -------------------- CONNECTIONS -------------------- */

    Connections {
        target: browserPageWebEngineView

        function onLoadingChanged(webEngineLoadingInfo) {
            leftSideNavBarLayout.backButton.enabled = browserPageWebEngineView.canGoBack
            leftSideNavBarLayout.forwardButton.enabled = browserPageWebEngineView.canGoForward

            switch (webEngineLoadingInfo.status) {

                case WebEngineView.LoadStartedStatus:
                    leftSideNavBarLayout.reloadButton.iconSource = "./assets/close_icon.svg"
                    leftSideNavBarLayout.reloadButton.func = function() {
                        browserPageWebEngineView.stop()
                    }
                    break

                case WebEngineView.LoadSucceededStatus:
                    leftSideNavBarLayout.reloadButton.iconSource = "./assets/reload_icon.png"
                    leftSideNavBarLayout.reloadButton.func = function() {
                        browserPageWebEngineView.reload()
                    }

                    historyController.addToTheHistory(
                        browserPageWebEngineView.title,
                        browserPageWebEngineView.url.toString(),
                        new Date().toISOString()
                    )
                    break

                case WebEngineView.LoadFailedStatus:
                    leftSideNavBarLayout.reloadButton.iconSource = "./assets/reload_icon.png"
                    leftSideNavBarLayout.reloadButton.func = function() {
                        browserPageWebEngineView.reload()
                    }
                    break
            }
        }

        function onUrlChanged() {            
            addressBar.cursorPosition = 0
        }
    }

    Connections {
        target: downloadController

        function onDownloadAdded() {
            rightSideNavBarLayout.downloadButton.visible = true
        }
    }

    Timer {
        id: debounceTimer

        interval: 300
        repeat: false

        onTriggered: {
            if(addressBar.text.length != 0 && addressBar.isFocus) {
                addressBarWebSearchController.search(addressBar.text)
                suggestionBoxPopup.open()
            } else if(suggestionBoxPopupList.count === 0){
                suggestionBoxPopup.close()
            }
        }
    }

    /* -------------------- POPUPS -------------------- */

    CustomPopup {
        id: suggestionBoxPopup

        width: addressBar.width
        height: 400

        x: centerSideNavBarLayout.x + navBarLayout.anchors.margins
        y: navBar.height - navBarLayout.anchors.margins

        ListView {
           id: suggestionBoxPopupList

            anchors.fill: parent

            clip: true
            interactive: false
            orientation: ListView.Vertical

            model: addressBarWebSearchController.model

            delegate: Button {
                id: suggestionBoxPopupListButton

                width: suggestionBoxPopup.width
                height: 40

                backgroundColor: themeController.getCurrentTheme.qss.popupButton.backgroundColor
                hoverColor: themeController.getCurrentTheme.qss.popupButton.hoverColor
                clickedColor: themeController.getCurrentTheme.qss.popupButton.clickedColor

                buttonText.text: model.text
                buttonText.color: themeController.getCurrentTheme.qss.global.fontColor

                Item {
                    id: spacer
                    Layout.fillWidth: true
                }

                onClicked: {
                    backend.setWebEngineViewUrl(model.text)
                    addressBar.isFocus = false
                    suggestionBoxPopup.close()
                }
            }
        }
    }

    CustomPopup {
        id: downloadPopup

        width: 360
        height: browserPageWebEngineView.height

        x: rightSideNavBarLayout.x - downloadPopup.width + rightSideNavBarLayout.downloadButton.width + navBarLayout.anchors.margins
        y: navBar.height

        ColumnLayout {
            id: downloadPopupLayout

            anchors.fill: parent
            spacing: 10

            Label {
                height: 40
                Layout.fillWidth: true

                text: "Download Recently"
                color: themeController.getCurrentTheme.qss.global.fontColor

                font.pixelSize: 18

                verticalAlignment: Text.AlignVCenter
            }

            ListView {
                id: downloadPopupListView

                clip: true
                interactive: false
                orientation: ListView.Vertical
                verticalLayoutDirection: ListView.TopToBottom

                Layout.fillWidth: true
                Layout.fillHeight: true

                model: downloadController.getModel

                delegate: Rectangle {
                    id: downloadItem

                    property bool hovered: false
                    property bool pressed: false

                    property color backgroundColor: themeController.getCurrentTheme.qss.popupButton.backgroundColor
                    property color hoverColor: themeController.getCurrentTheme.qss.popupButton.hoverColor
                    property color clickedColor: themeController.getCurrentTheme.qss.popupButton.clickedColor

                    signal clicked()

                    width: parent.width
                    height: 80

                    anchors.margins: 2

                    color: pressed
                        ? clickedColor
                        : hovered
                        ? hoverColor
                        : backgroundColor

                    Behavior on color {
                        ColorAnimation { 
                            duration: 180
                        }
                    }

                    GridLayout {
                        anchors.fill: parent

                        anchors.margins: 2

                        rows: 2
                        columns: 2

                        Text {
                            id: downloadItemText
                            text: fileName

                            font.pointSize: themeController.getCurrentTheme.qss.global.fontSize
                            color: themeController.getCurrentTheme.qss.global.fontColor

                            Layout.margins: 2

                            Layout.row: 0
                            Layout.column: 0
                        }

                        CustomProgressBar {
                            total: totalBytes
                            received: receivedBytes

                            Layout.margins: 2

                            Layout.row: 1

                            Layout.column: 0
                            Layout.columnSpan: 2

                            Layout.fillWidth: true
                        }
                    }

                    HoverHandler {
                        onHoveredChanged: downloadItem.hovered = hovered
                    }

                    TapHandler {
                        onPressedChanged: downloadItem.pressed = pressed
                        onTapped: {
                            downloadItem.clicked()
                        }
                    }
                }
            }
        }
    }

    CustomPopup {
        id: menuPopup

        width: 400 
        height: menuPopupLayout.contentHeight
        
        x: navBar.width - menuPopup.width
        y: navBar.height

        ColumnLayout {
            id: menuPopupLayout
            
            anchors.fill: parent
            anchors.margins: 0

            spacing: 0

            property var addTabButton: navBar.createMenuButton({
                "layout": menuPopupLayout,
                "iconSource": "./assets/new_tab_icon.png",
                "text": "Add Tab",
                "func": function() {
                    backend.createTab()
                }  
            })

            property var anonymousButton: navBar.createMenuButton({
                "layout": menuPopupLayout,
                "iconSource": "./assets/anonymous_icon.png",
                "text": "set in anonymous mode",
                "func": function() {
                    browserPageWebEngineView.profile.offTheRecord = true
                    browserPageWebEngineView.reload()
                }  
            })

            property var historyButton: navBar.createMenuButton({
                "layout": menuPopupLayout,
                "iconSource": "./assets/history_icon.png",
                "text": "history",
                "func": function() {
                    backend.setWebEngineViewUrl("viclion://history/history/")
                }  
            })

            property var settingsButton: navBar.createMenuButton({
                "layout": menuPopupLayout,
                "iconSource": "./assets/settings_icon.png",
                "text": "Settings",
                "func": function() {
                    backend.setWebEngineViewUrl("viclion://settings/general/")
                }  
            })

            property var quitButton: navBar.createMenuButton({
                "layout": menuPopupLayout,
                "iconSource": "./assets/quit_icon.png",
                "text": "Quit",
                "func": function() {
                    Qt.quit()
                }  
            })
        }
    }
}
