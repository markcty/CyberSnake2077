import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.12

Window {
    visible: true
    width: 1600
    height: 900
    color: "#272528"
    title: qsTr("Snake Game")
    Material.theme: Material.Dark

    GridLayout {
        id: gridLayout
        rowSpacing: 5
        anchors.fill: parent
        columns: 3
        property var gameBoardComponent
        property var gameBoard

        ColumnLayout {
            id: col1
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredWidth: 300
            Layout.preferredHeight: 500
            Button {
                id: startButton
                text: qsTr(gridLayout.gameBoard ? "Restart" : "Start")
                Layout.rightMargin: 0
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onClicked: {
                    if (gridLayout.gameBoard)
                        gridLayout.gameBoard.destroy()
                    gridLayout.gameBoard = gridLayout.gameBoardComponent.createObject(
                                col2)
                    gridLayout.gameBoard.focus = true
                    gridLayout.gameBoard.startGame()
                }
            }
            Button {
                id: quitButton
                text: qsTr("Quit")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onClicked: Qt.quit()
            }
            Button {
                id: pauseButton
                visible: gridLayout.gameBoard ? true : false
                text: qsTr(!gridLayout.gameBoard
                           || !gridLayout.gameBoard.running ? "Conitinue" : "Pause")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onClicked: {
                    gridLayout.gameBoard.running = !gridLayout.gameBoard.running
                }
            }
            Button {
                id: editMapButton
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                visible: {
                    if (!gridLayout.gameBoard)
                        return false
                    if (!gridLayout.gameBoard.running)
                        return true
                    return false
                }
                text: qsTr(gridLayout.gameBoard
                           && gridLayout.gameBoard.editMode ? "Finish" : "Edit Map")
                onClicked: {
                    gridLayout.gameBoard.editMode = !gridLayout.gameBoard.editMode
                    var t = gridLayout.gameBoard.editMode
                    pauseButton.enabled = !t
                    startButton.enabled = !t

                    addFoodButton.visible = t
                    addAccelerateButton.visible = t
                    addPlusLifeButton.visible = t
                    addBrickButton.visible = t
                }
            }
        }

        ColumnLayout {
            id: col2
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredWidth: 1000
            Layout.preferredHeight: 900
        }

        ColumnLayout {
            id: col3
            Layout.preferredHeight: 300
            Layout.preferredWidth: 300
            Button {
                id: addFoodButton
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                visible: false
                text: qsTr("Food")
                onClicked: {
                    gridLayout.gameBoard.randomlyGenerateItem(
                                gridLayout.gameBoard.foodComponent)
                }
            }
            Button {
                id: addAccelerateButton
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                visible: false
                text: qsTr("Accelerate")
                onClicked: {
                    gridLayout.gameBoard.randomlyGenerateItem(
                                gridLayout.gameBoard.accelerateComponent)
                }
            }
            Button {
                id: addPlusLifeButton
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                visible: false
                text: qsTr("Plus Life")
                onClicked: {
                    gridLayout.gameBoard.randomlyGenerateItem(
                                gridLayout.gameBoard.plusLifeComponent)
                }
            }
            Button {
                id: addBrickButton
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                visible: false
                text: qsTr("Brick")
                onClicked: {
                    gridLayout.gameBoard.randomlyGenerateItem(
                                gridLayout.gameBoard.brickComponent)
                }
            }
        }

        Component.onCompleted: {
            gameBoardComponent = Qt.createComponent("GameBoard.qml")
        }
    }
}
