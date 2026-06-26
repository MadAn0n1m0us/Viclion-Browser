import QtQuick 2.15

import QtWebEngine 1.9


WebEngineView {
    settings.webGLEnabled: false
    settings.showScrollBars: false
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

    onNavigationRequested: function(navigationRequest) {
        if (navigationRequest.navigationType === WebEngineNavigationRequest.RedirectNavigation & 
            ! WebEngineNavigationRequest.ReloadNavigation) {
            tabController.createTab("", "tab", navigationRequest.url.toString())
        }
    }

    onRenderProcessTerminated: function(status, exitCode) {
        console.log("Render process terminated")
        console.log("Status:", status)
        console.log("Exit code:", exitCode)
    }

    Connections {
        target: profileController

        function onCurrentProfileDataChanged(currentProfileData) {
            profile.persistentStoragePath = currentProfileData.persistentStoragePath
            profile.cachePath = currentProfileData.cachePath
            profile.downloadPath = currentProfileData.downloadPath
        }
    }
}
