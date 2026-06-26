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


class WebSearchModel(QtCore.QAbstractListModel):
    TextRole = QtCore.Qt.UserRole + 1

    def __init__(self, parent=None):
        self._parent = parent
        super().__init__(self._parent)
        
        self._data = []

    def rowCount(self, backend=None):
        return len(self._data)

    def data(self, index, role):
        if not index.isValid():
            return None

        if index.row() >= len(self._data):
            return None

        if role == self.TextRole:
            return self._data[index.row()]

        return None

    def roleNames(self):
        return {
            self.TextRole: b"text"
        }

    def setSuggestions(self, suggestions):
        self.beginResetModel()
        self._data = suggestions
        self.endResetModel()