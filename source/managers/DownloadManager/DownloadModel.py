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


class DownloadModel(QtCore.QAbstractListModel):
    FileNameRole = QtCore.Qt.UserRole + 1
    PathRole = QtCore.Qt.UserRole + 2
    StateRole = QtCore.Qt.UserRole + 3
    ReceivedBytesRole = QtCore.Qt.UserRole + 5
    TotalBytesRole = QtCore.Qt.UserRole + 4

    def __init__(self, parent=None):
        self._parent = parent
        super().__init__(self._parent)

        self.downloadsItemInfoList = []

    def rowCount(self, parent=QtCore.QModelIndex()):
        return len(self.downloadsItemInfoList)

    def data(self, index, role):
        if not index.isValid():
            return None

        item = self.downloadsItemInfoList[index.row()]

        if role == self.FileNameRole:
            return item["fileName"]
        if role == self.PathRole:
            return item["path"]
        if role == self.StateRole:
            return item["state"]
        if role == self.ReceivedBytesRole:
            return item["receivedBytes"]
        if role == self.TotalBytesRole:
            return item["totalBytes"]
        
        return None

    def roleNames(self):
        return {
            self.FileNameRole: b"fileName",
            self.PathRole: b"path",
            self.StateRole: b"state",
            self.ReceivedBytesRole: b"receivedBytes",
            self.TotalBytesRole: b"totalBytes"
        }

    def addToTheDownloads(self, downloadItem):
        self.beginInsertRows(
            QtCore.QModelIndex(),
            len(self.downloadsItemInfoList),
            len(self.downloadsItemInfoList)
        )

        self.downloadsItemInfoList.append(downloadItem)

        self.endInsertRows()

    def updateDownload(self, row, received, total):
        if row < 0 or row >= len(self.downloadsItemInfoList):
            return

        self.downloadsItemInfoList[row]["totalBytes"] = total
        self.downloadsItemInfoList[row]["receivedBytes"] = received

        index = self.index(row, 0)

        self.dataChanged.emit(
            index,
            index,
            [
                self.ReceivedBytesRole,
                self.TotalBytesRole
            ]
        )