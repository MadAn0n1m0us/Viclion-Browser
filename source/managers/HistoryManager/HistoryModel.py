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


class HistoryModel(QtCore.QAbstractListModel):
    TitleRole = QtCore.Qt.UserRole + 1
    UrlRole = QtCore.Qt.UserRole + 2
    DateRole = QtCore.Qt.UserRole + 3

    def __init__(self, parent=None):
        self._parent = parent
        super().__init__(self._parent)

        self.historyItemInfoList = []

    def rowCount(self, parent=QtCore.QModelIndex()):
        return len(self.historyItemInfoList)

    def data(self, index, role):

        if not index.isValid():
            return None

        item = self.historyItemInfoList[index.row()]

        if role == self.TitleRole:
            return item["title"]
        if role == self.UrlRole:
            return item["url"]
        if role == self.DateRole:
            return item["date"]

        return None

    def roleNames(self):
        return {
            self.TitleRole: b"title",
            self.UrlRole: b"url",
            self.DateRole: b"date",
        }

    @QtCore.pyqtSlot(str, str, str, str)
    def addToTheHistory(self, title: str, url: str, date: str):
        if self.historyItemInfoList and self.historyItemInfoList[-1]["url"] == url:
            return

        historyItemInfo = {
            "title": title,
            "url": url,
            "date": date,
        }

        self.beginInsertRows(
            QtCore.QModelIndex(),
            len(self.historyItemInfoList),
            len(self.historyItemInfoList)
        )
            
        self.historyItemInfoList.append(historyItemInfo)

        self.endInsertRows()
        
    def getTheHistory(self):
        return self.historyItemInfoList