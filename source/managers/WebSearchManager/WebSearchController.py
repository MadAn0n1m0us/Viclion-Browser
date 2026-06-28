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

from .WebSearchModel import WebSearchModel
from .WebSearchThread import WebSearchThread


class WebSearchController(QtCore.QObject):
    searchRequested = QtCore.pyqtSignal(str)
    suggestionsChanged = QtCore.pyqtSignal(list)

    def __init__(self, parent=None):
        self._parent = parent
        super().__init__(self._parent)

        self._model = WebSearchModel()
        
        self._thread = QtCore.QThread()
        self.webSearchThread = WebSearchThread()

        self.webSearchThread.moveToThread(self._thread)

        self.searchRequested.connect(self.webSearchThread.search)
        self.webSearchThread.resultsReady.connect(self.setSuggestions)

        self._thread.start()

    @QtCore.pyqtProperty(QtCore.QObject, constant=True)
    def model(self):
        return self._model

    @model.setter    
    def model(self, model: WebSearchModel):
        self._model = model

    @QtCore.pyqtSlot(str)
    def search(self, text: str):
        if not text:
            self._model.setSuggestions([])
            return
        if text.startswith(f"{AppData.APP_URL_SCHEME_NAME}://"):
            return
        self.searchRequested.emit(text)

    @QtCore.pyqtSlot(list)
    def setSuggestions(self, suggestions: list):
        self._model.setSuggestions(suggestions)
        self.suggestionsChanged.emit(suggestions)