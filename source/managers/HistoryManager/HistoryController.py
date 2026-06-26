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
import traceback

from PyQt5 import QtCore

from .HistoryModel import HistoryModel


class HistoryController(QtCore.QObject):
    historyChanged = QtCore.pyqtSignal()

    def __init__(self, parent=None):
        self._parent = parent
        super().__init__(self._parent)

        self.model = HistoryModel()

    @QtCore.pyqtSlot(str, str, str)
    def addToTheHistory(self, title: str, url: str, date: str):
        try:
            if not AppData.APP_URL_SHEME in url:
                self.model.addToTheHistory(title, url, date)
        except:
            traceback.print_exc()
    
    @QtCore.pyqtSlot(result="QVariantList")
    def getTheHistory(self):
        return self.model.getTheHistory()