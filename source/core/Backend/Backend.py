# Viclion Browser
# Copyright (C) 2026 MadAn0n1m0us
#
# This file is part of Viclion Browser.
#
# Viclion Browser is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Viclion Browser is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

import AppData as AppData

from PyQt5 import QtCore, QtWebEngineWidgets

from source.managers.TabManager import TabController
from source.managers.ThemeManager import ThemeController
from source.managers.ProfileManager import ProfileController
from source.managers.HistoryManager import HistoryController
from source.managers.DownloadManager import DownloadController
from source.managers.LanguageManager import LanguageController
from source.managers.ExtensionManager import ExtensionController
from source.managers.UrlSchemeManager import UrlSchemeController


class Backend(QtCore.QObject):
    def __init__(self):
        super().__init__()
        self.urlSchemeController = UrlSchemeController.UrlSchemeController(self)
        self.profileController = ProfileController.ProfileController(self)

        self.defaultProfile = self.profileController.createProfile("default")
        self.profileController.setCurrentProfile("default")

        self.currentWebEngineProfile = QtWebEngineWidgets.QWebEngineProfile.defaultProfile()

        self.initCurrentWebEngineProfile()

        self.extensionController = ExtensionController.ExtensionController(self)
        self.themeController = ThemeController.ThemeController(self)
        self.tabController = TabController.TabController(self)
        self.historyController = HistoryController.HistoryController(self)
        self.downloadController = DownloadController.DownloadController(self)
        self.languageController = LanguageController.LanguageController(self)

        self.profileController.currentProfileChanged.connect(self.initCurrentWebEngineProfile)

        self.currentWebEngineProfile.installUrlSchemeHandler(
            AppData.APP_URL_SHEME_NAME_BYTES, 
            self.urlSchemeController
        )

        self.currentWebEngineProfile.downloadRequested.connect(
            lambda downloadItem: self.downloadController.handleDownload(downloadItem)
        )

    def initCurrentWebEngineProfile(self):
        currentWebEngineProfileData = self.profileController.getCurrentProfileData

        self.currentWebEngineProfile.setPersistentStoragePath(currentWebEngineProfileData["persistentStoragePath"])
        self.currentWebEngineProfile.setCachePath(currentWebEngineProfileData["cachePath"])
        self.currentWebEngineProfile.setDownloadPath(currentWebEngineProfileData["downloadPath"])

        self.themeController.setCurrentTheme(currentWebEngineProfileData["currentThemeName"])

    @QtCore.pyqtSlot(result=str)
    def getCssCurrentTheme(self):
            return self.themeController.getCurrentTheme["css"]

    @QtCore.pyqtSlot(str)
    def setCurrentTheme(self, themeName: str):
        if themeName.lower() != "System":
            self.themeController.setCurrentTheme(themeName)

    @QtCore.pyqtSlot()
    def createTab(self):
        self.tabController.createTab(AppData.APP_ICON, "tab", AppData.currentWebEngineViewUrl)

    @QtCore.pyqtSlot(str)
    def setWebEngineViewUrl(self, url: str):
        if url.startswith(f"{AppData.APP_URL_SHEME_NAME}://"):
            finalUrl = url
        elif url.startswith("http://") or url.startswith("https://"):
            finalUrl = url
        elif "." in url:
            finalUrl = "https://" + url
        else:
            finalUrl = AppData.currentWebEngineSearchUrl + url

        finalUrl = finalUrl.replace(" ", "+")
        self.tabController.setWebEngineViewUrl(finalUrl)

    @QtCore.pyqtSlot(result=str)
    def getDownloadPath(self):
        downloadPath = self.currentWebEngineProfile.downloadPath()
        return downloadPath
    
    @QtCore.pyqtSlot(result='QVariantList')
    def getTheHistory(self):
        return self.historyController.getTheHistory()
