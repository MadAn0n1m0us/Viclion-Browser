import sys
import os
from PyQt5.QtCore import QObject, pyqtSlot, QUrl
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtWebEngine import QtWebEngine 

class Monbackend(QObject):
    def __init__(self):
        super().__init__()

    @pyqtSlot(str, result=str)
    def recevoir_de_html(self, texte):
        print(f"[Python] Reçu depuis le HTML : {texte}")
        return f"Succès : {texte}"

if __name__ == "__main__":
    QtWebEngine.initialize() 
    
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # --- CORRECTION ICI ---
    # On récupère le dossier où se trouve le script python actuel
    dossier_actuel = os.path.dirname(os.path.abspath(__file__))
    # On construit le chemin absolu vers le fichier HTML
    chemin_html = os.path.join(dossier_actuel, "index.html")
    # On transforme le chemin en URL valide pour le WebEngine (ex: file:///C:/...)
    url_html = QUrl.fromLocalFile(chemin_html).toString()
    
    backend = Monbackend()

    context = engine.rootContext()
    context.setContextProperty("monObjetPython", backend)
    # On envoie l'URL du fichier HTML directement au QML
    context.setContextProperty("urlFichierHtml", url_html)
    # ----------------------

    qml_path = os.path.join(dossier_actuel, "main.qml")
    engine.load(QUrl.fromLocalFile(qml_path))

    if not engine.rootObjects():
        sys.exit(-1)
        
    sys.exit(app.exec_())
