import QtQuick

import QtWebEngine


WebEngineView {
    settings.webGLEnabled: false
    settings.autoLoadImages: true
    settings.pluginsEnabled: false
    settings.errorPageEnabled: true
    settings.pdfViewerEnabled: true
    settings.javascriptEnabled: true
    settings.touchIconsEnabled: true
    settings.javascriptCanPaste: true
    settings.dnsPrefetchEnabled: false
    settings.localStorageEnabled: true
    settings.autoLoadIconsForPage: true
    settings.screenCaptureEnabled: true
    settings.fullScreenSupportEnabled: true
    settings.webRTCPublicInterfacesOnly: false
    settings.javascriptCanAccessClipboard: true
    settings.localContentCanAccessFileUrls: true
    settings.localContentCanAccessRemoteUrls: true

    backgroundColor: themeController.getCurrentTheme.qss.webEngineView.backgroundColor

    onNewWindowRequested: function(newWindowRequest) {
        if (newWindowRequest.destination !== WebEngineNewWindowRequest.InNewTab || WebEngineNewWindowRequest.InNewBackgroundTab) {
            tabController.createTab("", "tab", newWindowRequest.requestedUrl)
        }
    }

    Connections {
        target: profileController

        function onCurrentProfileChanged(currentProfileData) {
            profile.persistentStoragePath = currentProfileData.persistentStoragePath
            profile.cachePath = currentProfileData.cachePath
            profile.downloadPath = currentProfileData.downloadPath
        }
    }
}
