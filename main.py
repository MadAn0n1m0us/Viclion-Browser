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

import os
import sys

import AppData as AppData

from PyQt5 import QtQml, QtGui, QtWebEngine, QtWebEngineCore

from source.core.FramelessWindowManager import FramelessWindowController
from source.core.Backend import Backend

from source.managers.WebSearchManager import WebSearchController


if __name__ == "__main__":
    os.environ["QTWEBENGINE_CHROMIUM_FLAGS"] = "--disable-service-worker"

    scheme = QtWebEngineCore.QWebEngineUrlScheme(AppData.APP_URL_SHEME_NAME_BYTES)
    
    scheme.setSyntax(QtWebEngineCore.QWebEngineUrlScheme.Syntax.Host)
    scheme.setFlags(
        QtWebEngineCore.QWebEngineUrlScheme.Flag.SecureScheme |
        QtWebEngineCore.QWebEngineUrlScheme.Flag.LocalScheme | 
        QtWebEngineCore.QWebEngineUrlScheme.Flag.LocalAccessAllowed
    )

    QtWebEngineCore.QWebEngineUrlScheme.registerScheme(scheme)

    QtWebEngine.QtWebEngine.initialize()

    app = QtGui.QGuiApplication(AppData.ARGV)
    engine = QtQml.QQmlApplicationEngine()
    framelessWindowController = FramelessWindowController.FramelessWindowController()
    backend = Backend.Backend()

    app.setApplicationName(AppData.APP_NAME)
    app.setApplicationVersion(AppData.APP_VERSION)

    engineRootContext = engine.rootContext()
    engineRootContext.setContextProperty("backend", backend)
    engineRootContext.setContextProperty("tabController", backend.tabController)
    engineRootContext.setContextProperty("themeController", backend.themeController)
    engineRootContext.setContextProperty("historyController", backend.historyController)
    engineRootContext.setContextProperty("profileController", backend.profileController)
    engineRootContext.setContextProperty("downloadController", backend.downloadController)
    engineRootContext.setContextProperty("framelessWindowController", framelessWindowController)

    QtQml.qmlRegisterType(
        WebSearchController.WebSearchController, 
        "WebSearchManager", 1, 0, "WebSearchController"
    )

    engine.addImportPath(AppData.COMPONENTS_FOLDER)
    engine.load(os.path.join(AppData.SOURCE_FOLDER, "main.qml"))

    app.aboutToQuit.connect(engine.deleteLater)

    if not engine.rootObjects():
        sys.exit(-1)

    backend.createTab()

    sys.exit(app.exec())
