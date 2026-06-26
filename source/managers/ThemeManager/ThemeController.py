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

from PyQt5 import QtCore

from .ThemeModel import ThemeModel


class ThemeController(QtCore.QObject):
    changeCurrentThemeRequested = QtCore.pyqtSignal(str)

    def __init__(self, parent=None):
        self._parent = parent
        super().__init__(self._parent)

        self.worker = QtCore.QThread()
        self.model = ThemeModel()

        self.model.moveToThread(self.worker)

    @QtCore.pyqtProperty("QVariantMap", notify=changeCurrentThemeRequested)
    def getCurrentTheme(self):
        return self.model.getCurrentTheme()

    @QtCore.pyqtSlot(str)
    def setCurrentTheme(self, theme_name: str):
        self.model.setCurrentTheme(theme_name)
        self.changeCurrentThemeRequested.emit(theme_name)
