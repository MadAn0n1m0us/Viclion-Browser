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

from PyQt5 import QtCore

from .TabModel import TabModel


class TabController(QtCore.QObject):
    changeTabCountRequested = QtCore.pyqtSignal(int)
    currentIndexChanged = QtCore.pyqtSignal(int)

    tabCreated = QtCore.pyqtSignal()
    tabClosed = QtCore.pyqtSignal(int)

    def __init__(self, parent=None):
        self._parent = parent
        super().__init__(self._parent)

        self.model = TabModel()

    @QtCore.pyqtProperty(QtCore.QObject, constant=True)
    def setModel(self, model):
        self.model = model

    @QtCore.pyqtProperty(QtCore.QObject, constant=True)
    def getModel(self):
        return self.model
    
    @QtCore.pyqtProperty(int, notify=changeTabCountRequested)
    def tabCount(self):
        return self.model.tabCount

    @QtCore.pyqtSlot(str, str, QtCore.QObject)
    def createTab(self, icon, title, widget):
        self.model.createTab(icon, title, widget)
        self.tabCreated.emit()

    @QtCore.pyqtSlot(int)
    def closeTab(self, index):
        self.model.closeTab(index)
        self.tabClosed.emit(index)

    @QtCore.pyqtSlot(int, int)
    def moveTab(self, from_, to):
        self.model.moveTab(from_, to)

    @QtCore.pyqtProperty(int, notify=currentIndexChanged)
    def getCurrentIndex(self):
        return self.model.getCurrentIndex()

    @QtCore.pyqtSlot(int)
    def setCurrentIndex(self, index):
        self.model.setCurrentIndex(index)
        self.currentIndexChanged.emit(index)

    @QtCore.pyqtSlot(int, str)
    def setTabIconPath(self, index: int, iconPath: str):
        self.model.setTabIconPath(index, iconPath)

    @QtCore.pyqtSlot(int, str)
    def setTabTitle(self, index: int, title: str):
        self.model.setTabTitle(index, title)