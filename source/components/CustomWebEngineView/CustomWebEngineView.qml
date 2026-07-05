import QtQuick

import QtWebEngine


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
        navigationRequest.accept()

        if (navigationRequest.navigationType === WebEngineNavigationRequest.RedirectNavigation &&
            navigationRequest.navigationType !== WebEngineNavigationRequest.ReloadNavigation &&
            navigationRequest.navigationType === WebEngineNavigationRequest.OtherNavigation) {
                
            tabController.createTab("", "", navigationRequest.url)
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
