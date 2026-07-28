import os
import sys
from PyQt6.QtCore import QAbstractListModel, QModelIndex, Qt, QUrl, pyqtSlot
from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine

class MoveableModel(QAbstractListModel):
    NameRole = Qt.ItemDataRole.UserRole + 1

    def __init__(self, data=None):
        super().__init__()
        self._data = data or ["Item A", "Item B", "Item C", "Item D"]

    def rowCount(self, parent=QModelIndex()):
        return len(self._data)

    def data(self, index, role=Qt.ItemDataRole.DisplayRole):
        if not index.isValid() or not (0 <= index.row() < len(self._data)):
            return None
        if role == self.NameRole:
            return self._data[index.row()]
        return None

    def roleNames(self):
        return {self.NameRole: b"name"}

    @pyqtSlot(int, int)
    def moveItem(self, source_row, destination_row):
        """Moves an item from source_row to destination_row safely."""
        if source_row == destination_row:
            return

        # Handle QModelIndex architecture constraints for moving down
        # See Qt documentation for beginMoveRows logic
        visual_destination = destination_row
        if source_row < destination_row:
            visual_destination += 1

        # Notify QML that a move is starting
        if self.beginMoveRows(QModelIndex(), source_row, source_row, QModelIndex(), visual_destination):
            # Move the actual data in the Python list
            item = self._data.pop(source_row)
            self._data.insert(destination_row, item)
            # Notify QML that the move is complete
            self.endMoveRows()

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    dossier_actuel = os.path.dirname(os.path.abspath(__file__))

    my_model = MoveableModel()
    engine.rootContext().setContextProperty("myModel", my_model)

    qml_path = os.path.join(dossier_actuel, "main.qml")
    engine.load(QUrl.fromLocalFile(qml_path))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
