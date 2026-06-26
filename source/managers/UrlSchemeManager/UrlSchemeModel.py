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
import AppData as AppData


class UrlSchemeModel:
    @staticmethod
    def getInternalFiles():
        html_dict = {}
        dir_name = AppData.HTML_FOLDER
        for root, dirs, files in os.walk(dir_name):
            folder_name = os.path.basename(root)
            for file in files:
                filename, extension = os.path.splitext(file)
                if extension == ".html":
                    full_path = os.path.join(root, file)
                    with open(full_path, "r", encoding="utf-8") as f:
                        if folder_name not in html_dict:
                            html_dict[folder_name] = {}
                        html_dict[folder_name][filename] = f.read()
        return html_dict