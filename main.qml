import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Window {
    visible: true
    width: 1366
    height: 768
    color: "#2C2B30"
    title: qsTr("Snake Game")

    GridLayout {
        id: gridLayout
        rowSpacing: 5
        anchors.fill: parent
        columns: 2

        ColumnLayout {
            id: buttonColLayout
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredWidth: 300
            Layout.preferredHeight: 300

            spacing: 0

            Button {
                id: startButton
                text: "Start"
                Layout.rightMargin: 0
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                font.pointSize: 15
                onClicked: gameBoard.startGame()
            }

            Button {
                id: quitButton
                text: "Quit"
                font.pointSize: 15

                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
        }

        Item {
            height: 600
            width: 600

            Rectangle {
                id: boardBorder
                color: "#212121"
                anchors.fill: parent
                radius: 20
            }
            RectangularGlow {
                id: effect
                anchors.fill: boardBorder
                glowRadius: 20
                spread: 0.2
                color: "#212121"
                cornerRadius: boardBorder.radius + glowRadius
            }
            GameBoard {
                id: gameBoard
            }
        }
    }
}
