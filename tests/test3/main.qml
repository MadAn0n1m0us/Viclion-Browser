import QtQuick
import QtQuick.Controls

Window {
    width: 300
    height: 400
    visible: true
    title: "Move ListView Item"

    ListView {
        id: listView
        anchors.fill: parent
        anchors.margins: 20
        model: myModel
        spacing: 5

        // Optional: Adds visual glide when items move
        move: Transition {
            NumberAnimation { properties: "y"; duration: 250; easing.type: Easing.InOutQuad }
        }

        delegate: Rectangle {
            width: listView.width
            height: 50
            color: "lightblue"
            border.color: "dodgerblue"
            radius: 4

            Row {
                anchors.centerIn: parent
                spacing: 20
                
                Text {
                    text: model.name
                    font.pixelSize: 16
                }

                // Button to move item down
                Button {
                    text: "↓"
                    enabled: index < listView.count - 1
                    onClicked: myModel.moveItem(index, index + 1)
                }
                
                // Button to move item up
                Button {
                    text: "↑"
                    enabled: index > 0
                    onClicked: myModel.moveItem(index, index - 1)
                }
            }
        }
    }
}
