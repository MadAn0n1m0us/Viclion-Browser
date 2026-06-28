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
import AppData

from PyQt5 import QtCore


class ThemeModel(QtCore.QObject):
    def __init__(self, parent=None):
        self._parent = parent
        super().__init__(self._parent)

        self.themesDict = self.getAllThemes()

        self.currentThemeName = ""
        self.currentTheme = self.themesDict.get(self.currentThemeName, {})

    def getCurrentThemeName(self):
        return self.currentThemeName

    def getCurrentTheme(self):
        return self.themesDict.get(self.currentThemeName, {})

    def setCurrentTheme(self, themeName: str):
        if themeName in self.themesDict and themeName != self.currentThemeName:
            self.currentThemeName = themeName
            self.currentTheme = self.themesDict[themeName]

    @staticmethod
    def getAllThemes():
        themesDict = {}
        dir_name = AppData.GLOBAL_THEMES_FOLDER
        for root, _, files in os.walk(dir_name):
            themeName = os.path.basename(root)
            themesDict[themeName] = {}
            for file in files:
                _, extension = os.path.splitext(file)
                fullPath = os.path.join(root, file)
                with open(fullPath, "r", encoding="utf-8") as f:
                    if extension == ".json":
                        themesDict[themeName]["qss"] = json.load(f)
                    if extension == ".css":
                        themesDict[themeName]["css"] = f.read()       
        return themesDict