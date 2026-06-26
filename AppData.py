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


PROJECT_FOLDER = os.path.join(os.path.dirname(__file__)).replace(r"\\", "/")

ARGV = sys.argv

APP_NAME = "Viclion Browser"
APP_ICON = "../../favicon.ico"
APP_VERSION = "Beta v1.0.0"

GLOBAL_THEMES_FOLDER = f"{PROJECT_FOLDER}/themes"
SOURCE_FOLDER = f"{PROJECT_FOLDER}/source"
PROFILES_DATA_FOLDER = f"{PROJECT_FOLDER}/profiles"

PROFILES_DATA_LIST_FILE = f"{PROFILES_DATA_FOLDER}/profiles.json"

COMPONENTS_FOLDER = f"{SOURCE_FOLDER}/components"
HTML_FOLDER = f"{SOURCE_FOLDER}/html"

downloadDir = os.path.join(os.path.expanduser("~"), "Downloads")

APP_URL_SHEME_NAME = "viclion"
APP_URL_SHEME_NAME_BYTES = APP_URL_SHEME_NAME.encode()
APP_URL_SHEME = f"{APP_URL_SHEME_NAME}://"

currentWebEngineViewUrl = "viclion://home/index"

currentWebEngineUrl = "https://www.google.com/"
currentWebEngineSearchUrl = f"{currentWebEngineUrl}search?q="
currentWebEngineSearchApiUrl = f"https://suggestqueries.google.com/complete/search"