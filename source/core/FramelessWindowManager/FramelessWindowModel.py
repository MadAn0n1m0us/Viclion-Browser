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

import ctypes

from ctypes import wintypes

from PyQt5 import QtCore, QtQuick

WM_GETMINMAXINFO = 0x0024
WM_NCCALCSIZE = 0x0083
WM_NCACTIVATE = 0x0086
WM_NCHITTEST = 0x0084
HTCLIENT = 1
HTCAPTION = 2
HTLEFT = 10
HTRIGHT = 11
HTTOP = 12
HTTOPLEFT = 13
HTTOPRIGHT = 14
HTBOTTOM = 15
HTBOTTOMLEFT = 16
HTBOTTOMRIGHT = 17

GWL_STYLE = -16
WS_MAXIMIZE = 0x01000000

user32 = ctypes.windll.user32


class MSG(ctypes.Structure):
    _fields_ = [
        ("hwnd", wintypes.HWND),
        ("message", wintypes.UINT),
        ("wParam", wintypes.WPARAM),
        ("lParam", wintypes.LPARAM),
        ("time", wintypes.DWORD),
        ("pt_x", ctypes.c_long),
        ("pt_y", ctypes.c_long),
    ]

class FramelessWindowModel(QtCore.QObject):
    BORDER_WIDTH = 4

    def __init__(self):
        super().__init__()
        self.__window = None
        self.__title_bar = None
        self.__excludedDragRectList = []

    def getWindow(self):
        return self.__window

    @QtCore.pyqtSlot(QtCore.QObject)
    def setWindow(self, window):
        self.__window = window

    def getTitleBar(self):
        return self.__title_bar

    @QtCore.pyqtSlot(QtQuick.QQuickItem)
    def setTitleBar(self, title_bar):
        if self.__title_bar != title_bar:
            self.__title_bar = title_bar
    
    @QtCore.pyqtSlot()
    def getExcludedDragRectList(self):
        return self.__excludedDragRectList
    
    @QtCore.pyqtSlot('QVariant', 'QVariant', 'QVariant', 'QVariant')
    def addToExcludedDragRectList(self, x, y, w, h):
        rect = QtCore.QRect(int(x), int(y), int(w), int(h))
        self.__excludedDragRectList.append(rect)
    
    @QtCore.pyqtSlot()
    def clearExcludedDragRectList(self):
        self.__excludedDragRectList.clear()