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
import json
import shutil

import AppData

from PyQt5 import QtCore


class ProfileModel(QtCore.QAbstractListModel):
    def __init__(self, parent=None):
        self._parent = parent
        super().__init__(self._parent)

        self.currentProfileName: str = ""
        self.currentProfileData: dict = None

        with open(AppData.PROFILES_DATA_LIST_FILE, "r", encoding="utf-8") as f:
            self.profilesDataListFileContent = json.load(f)

    def getCurrentProfileData(self):
        return self.currentProfileData

    def setCurrentProfile(self, profileName: str):
        profileData = self.findProfileData(profileName)

        if profileData:
            self.currentProfileData = profileData
            self.currentProfileName = profileName

    def addToTheProfiles(self, profileData: dict):
        profilesDataList = self.profilesDataListFileContent["profiles"]

        profileName = profileData["profileName"]

        profilesDataList[profileName] = {
            "persistentStoragePath": profileData["persistentStoragePath"],
            "cachePath": profileData["cachePath"],
            "downloadPath": profileData["downloadPath"] 
        }

        with open(AppData.PROFILES_DATA_LIST_FILE, "w", encoding="utf-8") as f:
            json.dump(self.profilesDataListFileContent, f, indent=4, ensure_ascii=False)

    def deleteProfile(self, profileName: str):
        profilesDataList = self.profilesDataListFileContent["profiles"]

        if profileName not in profilesDataList:
            return False

        profileData = profilesDataList[profileName]

        persistentStoragePath = profileData["persistentStoragePath"]
        cachePath = profileData["cachePath"]

        if persistentStoragePath and os.path.exists(persistentStoragePath):
            shutil.rmtree(persistentStoragePath, ignore_errors=True)

        if cachePath and os.path.exists(cachePath):
            shutil.rmtree(cachePath, ignore_errors=True)

        del profilesDataList[profileName]

        with open(AppData.PROFILES_DATA_LIST_FILE, "w", encoding="utf-8") as f:
            json.dump(self.profilesDataListFileContent, f, indent=4, ensure_ascii=False)

        if self.currentProfileName == profileName:
            self.currentProfileName = ""
            self.currentProfileData = None

        return True 

    def findProfileData(self, profileName: str):
        profilesDataList = self.profilesDataListFileContent["profiles"]
        if profileName in profilesDataList:
            return profilesDataList[profileName]
        return None