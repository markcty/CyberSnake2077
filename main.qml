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
                id: newBoardButton
                text: qsTr("new Board")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onClicked: {
                    gridLayout.gameBoard.destroy()
                    gridLayout.gameBoard = gridLayout.gameBoardComponent.createObject(
                                col2)
                    newPlayerButton.enabled = true
                    newAiSnakeButton.enabled = true
                    runningButton.enabled = false
                }
                Material.background: '#4CAF50'
            }
            Button {
                id: newPlayerButton
                text: qsTr("new Player")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onClicked: {
                    gridLayout.gameBoard.addPlayer()
                    if (gridLayout.gameBoard.players === 2)
                        newPlayerButton.enabled = false
                    runningButton.enabled = true
                }
                onEnabledChanged: {
                    if (gridLayout.gameBoard.players === 2)
                        enabled = false
                }
                Material.background: '#009688'
            }
            Button {
                id: newAiSnakeButton
                text: qsTr("new AI Snake")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onClicked: {
                    gridLayout.gameBoard.addAiSnake()
                    if (gridLayout.gameBoard.aiSnakes === 2)
                        newAiSnakeButton.enabled = false
                    runningButton.enabled = true
                }
                Material.background: '#009688'
            }
            Button {
                id: runningButton
                text: qsTr(gridLayout.gameBoard.running ? "Pause" : "Start")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                enabled: false
                onClicked: {
                    gridLayout.gameBoard.running = !gridLayout.gameBoard.running
                    newPlayerButton.enabled = !gridLayout.gameBoard.running
                    newAiSnakeButton.enabled = !gridLayout.gameBoard.running
                }
                Material.background: '#E91E63'
            }
            Button {
                id: quitButton
                text: qsTr("Quit")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onClicked: Qt.quit()
                Material.background: '#607D8B'
            }
        }

        Item {
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
                id: editMapButton
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                enabled: gridLayout.gameBoard.running ? false : true
                text: qsTr(gridLayout.gameBoard
                           && gridLayout.gameBoard.editMode ? "Finish" : "Edit Map")
                onClicked: {
                    gridLayout.gameBoard.editMode = !gridLayout.gameBoard.editMode
                    var t = gridLayout.gameBoard.editMode
                    runningButton.enabled = !t
                    addFoodButton.visible = t
                    addAccelerateButton.visible = t
                    addPlusLifeButton.visible = t
                    addBrickButton.visible = t
                    addColorAllergyButton.visible = t
                    newBoardButton.enabled = !t
                }
                Material.background: '#795548'
            }
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
                id: addColorAllergyButton
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                visible: false
                text: qsTr("Color Allergy")
                onClicked: {
                    gridLayout.gameBoard.randomlyGenerateItem(
                                gridLayout.gameBoard.colorAllergyComponent)
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
            gridLayout.gameBoard = gridLayout.gameBoardComponent.createObject(
                        col2)
        }
    }
}
