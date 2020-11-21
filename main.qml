import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Window {
    visible: true
    width: 1366
    height: 768
    color: "black"
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
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                font.pointSize: 15
                onClicked: gameBoard.startGame()
            }

            Button {
                id: quitButton
                text: "Quit"
                font.pointSize: 15

                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }
        }

        ColumnLayout {
            id: canvasColLayout
            Layout.preferredWidth: 800
            Layout.preferredHeight: 768
            Layout.alignment: Qt.AlignCenter
            GameBoard {
                id: gameBoard
            }
        }
    }
}
