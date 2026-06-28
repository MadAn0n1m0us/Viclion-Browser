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
import requests

from PyQt5 import QtCore


class WebSearchThread(QtCore.QObject):
    resultsReady = QtCore.pyqtSignal(list)
            
    def __init__(self, parent=None):
        self._parent = parent
        super().__init__(self._parent)

    @QtCore.pyqtSlot(str)
    def search(self, query: str):
        if not query:
            self.resultsReady.emit([])
            return
        else: 
            try:
                response = requests.get(
                    AppData.currentWebEngineSearchApiUrl,
                    params = {
                        "client": "firefox",
                        "q": query
                    },
                )

                results = response.json()
                suggestions = results[1]
            except:
                suggestions = []
        self.resultsReady.emit(suggestions)