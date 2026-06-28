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


class ExtensionController(QtCore.QObject):
    def __init__(self, api: QtCore.QObject, parent=None):
        self._parent = parent
        self.api = api
        super().__init__(self._parent)

    def install(self):
        pass

    def uninstall(self):
        pass

    def setEnable(self):
        pass

    def setDisable(self):
        pass