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
import win32api
import win32con
import win32gui

from PyQt5 import QtGui, QtCore, QtQuick

from .FramelessWindowModel import (
    user32,
    WM_NCACTIVATE,
    WM_NCCALCSIZE,
    GWL_STYLE,
    WS_MAXIMIZE,
    WM_NCHITTEST, 
    HTCAPTION, 
    HTCLIENT,
    HTTOP, 
    HTLEFT, 
    HTRIGHT, 
    HTBOTTOM,
    HTTOPLEFT, 
    HTTOPRIGHT, 
    HTBOTTOMLEFT, 
    HTBOTTOMRIGHT,
    MSG,
    FramelessWindowModel
)


class FramelessNativeEventFilter(QtCore.QAbstractNativeEventFilter):
    def __init__(self, controller):
        super().__init__()
        self.controller = controller

    def nativeEventFilter(self, eventType, message):
        msg = MSG.from_address(int(message))

        if msg.message == WM_NCCALCSIZE:
                if msg.wParam:
                    rect = ctypes.cast(msg.lParam, ctypes.POINTER(ctypes.c_int * self.controller.model.BORDER_WIDTH)).contents

                    if self.controller.isMaximized(msg.hwnd):
                        monitor = win32api.MonitorFromWindow(msg.hwnd, win32con.MONITOR_DEFAULTTONEAREST)
                        monitor_info = win32api.GetMonitorInfo(monitor)
                        work_area = monitor_info['Work']

                        rect[0] = work_area[0]
                        rect[1] = work_area[1]
                        rect[2] = work_area[2]
                        rect[3] = work_area[3]

                        return True, 0

                return True, 0
        
        if msg.message == WM_NCACTIVATE:
            return True, 1

        if msg.message == WM_NCHITTEST:
            result = self.controller.handle_nchittest(msg.hwnd, msg)
            if result is not None:
                return True, result
        return False, 0


class FramelessWindowController(QtCore.QObject):
    framelessWindowSizeChanged = QtCore.pyqtSignal(bool)
    framelessWindowStateChanged = QtCore.pyqtSignal(QtCore.Qt.WindowState)

    def __init__(self):
        super().__init__()

        self.model = FramelessWindowModel()
        self.__event_filter = FramelessNativeEventFilter(self)

        QtGui.QGuiApplication.instance().installNativeEventFilter(self.__event_filter)

    def isMaximized(self, hwnd):
        style = user32.GetWindowLongW(hwnd, GWL_STYLE)
        return bool(style & WS_MAXIMIZE)
    
    def getWindow(self):
        return self.model.getWindow()

    @QtCore.pyqtSlot(QtCore.QObject)
    def setWindow(self, window):
        self.model.setWindow(window)

        hwnd = int(window.winId())

        style = win32gui.GetWindowLong(hwnd, win32con.GWL_STYLE)

        style |= win32con.WS_THICKFRAME
        style |= win32con.WS_MINIMIZEBOX
        style |= win32con.WS_MAXIMIZEBOX
        style &= ~win32con.WS_CAPTION 
        style |= win32con.WS_SYSMENU

        win32gui.SetWindowLong(hwnd, win32con.GWL_STYLE, style)

        win32gui.SetWindowPos(
            hwnd,
            None,
            0, 0, 0, 0,
            win32con.SWP_FRAMECHANGED |
            win32con.SWP_NOMOVE |
            win32con.SWP_NOSIZE |
            win32con.SWP_NOZORDER |
            win32con.SWP_NOACTIVATE
        )

        self.framelessWindowStateChanged.emit(window.windowState())
    
    def getTitleBar(self):
        return self.model.getTitleBar()
    
    @QtCore.pyqtSlot(QtQuick.QQuickItem)
    def setTitleBar(self, titleBar):
        self.model.setTitleBar(titleBar)

    @QtCore.pyqtSlot()
    def getWindowState(self):
        window = self.model.getWindow()
        if window is not None:
            return window.windowState() 

    @QtCore.pyqtSlot()
    def minimizeWindow(self):
        if self.getWindow():
            hwnd = int(self.getWindow().winId())
            win32gui.ShowWindow(hwnd, win32con.SW_MINIMIZE)

    @QtCore.pyqtSlot()
    def restoreWindow(self):
        if self.getWindow():
            self.getWindow().showNormal()
            self.framelessWindowStateChanged.emit(QtCore.Qt.WindowState.WindowNoState)

    @QtCore.pyqtSlot()
    def maximizeWindow(self):
        if self.getWindow():
            self.getWindow().showMaximized()
            self.framelessWindowStateChanged.emit(QtCore.Qt.WindowState.WindowMaximized)

    @QtCore.pyqtSlot()
    def toggleMaximizeRestore(self):
        if not self.getWindow():
            return
        self.restoreWindow() if self.getWindow().windowState() & QtCore.Qt.WindowState.WindowMaximized else self.maximizeWindow()    

    @QtCore.pyqtSlot()
    def closeWindow(self):
        if self.getWindow():
            self.getWindow().close()

    @QtCore.pyqtSlot()
    def getExcludedDragRectList(self):
        return self.model.getExcludedDragRectList()
    
    @QtCore.pyqtSlot('QVariant', 'QVariant', 'QVariant', 'QVariant')
    def addToExcludedDragRectList(self, x, y, w, h):
        self.model.addToExcludedDragRectList(x, y, w, h)

    @QtCore.pyqtSlot()
    def clearExcludedDragRectList(self):
        self.model.clearExcludedDragRectList()

    def pointInExcludedRegions(self, x, y):
        return any(rect.contains(x, y) for rect in self.getExcludedDragRectList())

    def handle_nchittest(self, hwnd, msg):
        if self.getWindow() is None:
            return None

        x = ctypes.c_short(msg.lParam & 0xffff).value
        y = ctypes.c_short((msg.lParam >> 16) & 0xffff).value

        geo = self.getWindow().geometry()
        wx, wy, ww, wh = geo.x(), geo.y(), geo.width(), geo.height()

        local_x = x - wx
        local_y = y - wy

        if not self.isMaximized(hwnd):
            if local_x < self.model.BORDER_WIDTH and local_y < self.model.BORDER_WIDTH:
                return HTTOPLEFT
            if local_x >= ww - self.model.BORDER_WIDTH and local_y < self.model.BORDER_WIDTH:
                return HTTOPRIGHT
            if local_x < self.model.BORDER_WIDTH and local_y >= wh - self.model.BORDER_WIDTH:
                return HTBOTTOMLEFT
            if local_x >= ww - self.model.BORDER_WIDTH and local_y >= wh - self.model.BORDER_WIDTH:
                return HTBOTTOMRIGHT
            if local_x < self.model.BORDER_WIDTH:
                return HTLEFT
            if local_x >= ww - self.model.BORDER_WIDTH:
                return HTRIGHT
            if local_y < self.model.BORDER_WIDTH:
                return HTTOP
            if local_y >= wh - self.model.BORDER_WIDTH:
                return HTBOTTOM
            
        titleBar = self.getTitleBar()

        if titleBar:
            titleBarItems = titleBar.childItems()
            if titleBarItems:
                for childItem in titleBarItems:
                    if hasattr(childItem, "childItems"):
                        subChildItems = childItem.childItems()
                        for subChild in subChildItems:
                            self.addToExcludedDragRectList(
                                subChild.x(), subChild.y(),
                                subChild.width(), subChild.height()
                            )
                    else:
                        self.addToExcludedDragRectList(
                            childItem.x(), childItem.y(),
                            childItem.width(), childItem.height()
                        )
                        
            if (titleBar.x() <= local_x <= titleBar.x() + titleBar.width() and 
                titleBar.y() <= local_y <= titleBar.y() + titleBar.height() and 
                not self.pointInExcludedRegions(local_x, local_y)):
                return HTCAPTION
            
        if self.isMaximized(hwnd):
            return HTCLIENT
        
        return HTCLIENT
