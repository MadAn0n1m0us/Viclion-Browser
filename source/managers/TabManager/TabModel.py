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

import AppData

from PyQt6 import QtCore


class TabModel(QtCore.QAbstractListModel):
    tabIconPathRole = QtCore.Qt.ItemDataRole.UserRole + 1
    tabTitleRole = QtCore.Qt.ItemDataRole.UserRole + 2
    tabAcitveRole = QtCore.Qt.ItemDataRole.UserRole + 3
    tabUrlRole = QtCore.Qt.ItemDataRole.UserRole + 4

    tabCountChanged = QtCore.pyqtSignal(int)
    
    def __init__(self, parent=None):
        self._parent = parent
        super().__init__(self._parent)
        
        self._tabs = []
        self.__currentIndex = 0

    @QtCore.pyqtProperty(int, notify=tabCountChanged)
    def tabCount(self):
        return len(self._tabs)

    def rowCount(self, parent=QtCore.QModelIndex()):
        return len(self._tabs)

    def data(self, index, role):
        if not index.isValid():
            return None

        tab = self._tabs[index.row()]

        if role == self.tabIconPathRole:
            return tab["iconPath"]
        if role == self.tabTitleRole:
            return tab["title"]
        if role == self.tabAcitveRole:
            return tab["active"]
        if role == self.tabUrlRole:
            return tab["url"]
        return None

    def roleNames(self):
        return {
            self.tabIconPathRole: b"iconPath",
            self.tabTitleRole: b"title",
            self.tabAcitveRole: b"active",
            self.tabUrlRole: b"url"
        }
        
    def createTab(self, iconPath: str, title: str, url: str):
        self.beginInsertRows(QtCore.QModelIndex(), len(self._tabs), len(self._tabs))

        self._tabs.append({
            "iconPath": iconPath,
            "title": title,
            "active": True,
            "url": url
        })

        self.endInsertRows()

        self.tabCountChanged.emit(self.rowCount())

        if self.__currentIndex >= len(self._tabs):
            self.__currentIndex = len(self._tabs) - 1

    def closeTab(self, index: int):
        if 0 <= index < len(self._tabs):
            self.beginRemoveRows(QtCore.QModelIndex(), index, index)

            self._tabs.pop(index)

            self.endRemoveRows()

            self.tabCountChanged.emit(self.rowCount())

            if self.__currentIndex >= len(self._tabs):
                self.__currentIndex = len(self._tabs) - 1

    def moveTab(self, from_: int, to: int):
        if from_ == to:
            return

        self.beginMoveRows(
            QtCore.QModelIndex(),
            from_,
            from_,
            QtCore.QModelIndex(),
            to + (1 if to > from_ else 0)
        )

        tab = self._tabs.pop(from_)
        self._tabs.insert(to, tab)

        self.endMoveRows()

    def getCurrentIndex(self):
        return self.__currentIndex
    
    def setCurrentIndex(self, index: int):
        if 0 <= index < len(self._tabs):
            self.__currentIndex = index

    def getTabIconPath(self, index: str):
        if 0 <= index < len(self._tabs):
            return self._tabs[index]["iconPath"]

    def setTabIconPath(self, index: int, iconPath: str):
        if 0 <= index < len(self._tabs):
            self._tabs[index]["iconPath"] = iconPath

            _index = self.index(index)
            self.dataChanged.emit(_index, _index, [self.tabIconPathRole])

    def getTabTitle(self, index: str):
        if 0 <= index < len(self._tabs):
            return self._tabs[index]["title"]

    def setTabTitle(self, index: int, title: str):
        if 0 <= index < len(self._tabs):
            self._tabs[index]["title"] = title

            _index = self.index(index)    
            self.dataChanged.emit(_index, _index, [self.tabTitleRole])

    def getTabUrl(self, index: str):
        if 0 <= index < len(self._tabs):
            return self._tabs[index]["url"]
  
    def setTabUrl(self, index: int, url: str):
        if 0 <= index < len(self._tabs):
            self._tabs[index]["url"] = url

            _index = self.index(index)    
            self.dataChanged.emit(_index, _index, [self.tabUrlRole])
