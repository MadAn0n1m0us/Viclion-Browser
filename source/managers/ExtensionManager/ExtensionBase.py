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

from PyQt5.QtCore import QObject, pyqtSignal


class ExtensionBase(QObject):
    """
    Classe de base que toute extension Viclion doit hériter.

    Convention obligatoire dans main.py de l'extension :
        class Extension(ExtensionBase):
            ...

    Le manifest.json doit contenir au minimum :
        {
            "id":          "mon_extension",
            "name":        "Mon Extension",
            "version":     "1.0.0",
            "description": "Ce que fait l'extension",
            "author":      "Ton nom",
            "autoEnable": true
        }
    """

    def __init__(self, manifest: dict, api):
        super().__init__()
        self.manifest = manifest
        self.api = api
        self.enabled = False

    @property
    def id(self): 
        return self.manifest.get("id", "")
    @property
    def name(self): 
        return self.manifest.get("name", "")
    @property
    def version(self): 
        return self.manifest.get("version", "")
    @property
    def description(self): 
        return self.manifest.get("description", "")
    @property
    def author(self): 
        return self.manifest.get("author", "")
    @property
    def icon(self): 
        return self.manifest.get("icon", "")

    # ── Cycle de vie (à surcharger dans chaque extension) ────
    def onInstall(self):
        """Appelé une seule fois à l'installation."""
        pass

    def onUninstall(self):
        """Appelé juste avant la suppression des fichiers."""
        pass

    def onEnable(self):
        """Appelé chaque fois que l'extension est activée."""
        pass

    def onDisable(self):
        """Appelé chaque fois que l'extension est désactivée."""
        pass