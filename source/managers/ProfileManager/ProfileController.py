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

import os

import AppData as AppData

from PyQt5 import QtCore

from .ProfileModel import ProfileModel


class ProfileController(QtCore.QObject):
    profileCreated = QtCore.pyqtSignal()
    currentProfileChanged = QtCore.pyqtSignal()
    currentProfileDataChanged = QtCore.pyqtSignal(dict)

    def __init__(self, parent=None):
        self._parent = parent
        super().__init__(self._parent)

        self.model = ProfileModel()

    def getModel(self):
        return self.model
    
    @QtCore.pyqtProperty(QtCore.QObject, notify=currentProfileDataChanged)
    def getCurrentProfileData(self):
        return self.model.getCurrentProfileData()

    def setCurrentProfile(self, profileName):
        self.model.setCurrentProfile(profileName)
        currentProfileData = self.model.findProfileData(profileName)
        self.currentProfileDataChanged.emit(currentProfileData)
        self.currentProfileChanged.emit()

    def createProfile(self, profileName: str, theme: str="Dark Theme"):
        persistentStoragePath = f"{AppData.PROFILES_DATA_FOLDER}/{profileName}"
        cacheProfilePath = f"{persistentStoragePath}/cache"

        profileData = {
            "profileName": profileName,
            "persistentStoragePath": persistentStoragePath,
            "theme": theme,
            "cachePath": cacheProfilePath,
            "downloadPath": AppData.downloadDir
        }

        self.model.addToTheProfiles(profileData)
        self.profileCreated.emit()
    
    def findProfileData(self, profileName: str):
        return self.model.findProfileData(profileName)