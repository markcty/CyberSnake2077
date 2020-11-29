import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Window {
    visible: true
    width: 1366
    height: 768
    color: "#272528"
    title: qsTr("Snake Game")

    GridLayout {
        id: gridLayout
        rowSpacing: 5
        anchors.fill: parent
        columns: 2
        property var gameBoardComponent
        property var gameBoard

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
                onClicked: {
                    if (gridLayout.gameBoard)
                        gridLayout.gameBoard.destroy()
                    gridLayout.gameBoard = gridLayout.gameBoardComponent.createObject(
                                gridLayout)
                    gridLayout.gameBoard.focus = true
                    gridLayout.gameBoard.startGame()
                }
            }

            Button {
                id: quitButton
                text: "Quit"
                font.pointSize: 15

                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
        }

        Component.onCompleted: {
            gridLayout.gameBoardComponent = Qt.createComponent("GameBoard.qml")
        }
    }
}
