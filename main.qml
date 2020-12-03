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
    Material.accent: '#795548'

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
                Layout.rightMargin: 0
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onClicked: {
                    gridLayout.gameBoard.destroy()
                    gridLayout.gameBoard = gridLayout.gameBoardComponent.createObject(
                                col2)
                }
            }
            Button {
                id: runningButton
                text: qsTr(gridLayout.gameBoard.running ? "Pause" : "Start")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onClicked: {
                    gridLayout.gameBoard.running = !gridLayout.gameBoard.running
                }
            }
            Button {
                id: quitButton
                text: qsTr("Quit")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onClicked: Qt.quit()
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
                id: editMapButton
                highlighted: true
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
                id: addBrickButton
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                visible: false
                text: qsTr("Brick")
                onClicked: {
                    gridLayout.gameBoard.randomlyGenerateItem(
                                gridLayout.gameBoard.brickComponent)
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
        }

        Component.onCompleted: {
            gameBoardComponent = Qt.createComponent("GameBoard.qml")
            gridLayout.gameBoard = gridLayout.gameBoardComponent.createObject(
                        col2)
        }
    }
}
