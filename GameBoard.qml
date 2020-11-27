import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id: gameBoard
    width: 800
    height: 800
    property real atomSize: 30
    property var snake
    property var snakeComponent
    property var board
    property int size: canvas.height / atomSize
    property var plusLifeComponent
    property var accelerateComponent
    property var foodComponent
    property int plusLifeNum: 2
    property int acclerateNum: 2
    property int foodNumber: 5

    RectangularGlow {
        id: canvasGlow
        anchors.fill: canvas
        spread: 0.2
        glowRadius: 10
        color: "#2e91ed"
        cornerRadius: canvas.radius + glowRadius
    }

    Rectangle {
        id: canvas
        width: 600
        height: 600
        color: '#212121'
        radius: 20
        anchors.verticalCenter: parent.verticalCenter
    }

    Keys.onPressed: {
        if (!snake)
            return
        // to-do: user input stack
        switch (event.key) {
        case Qt.Key_W:
            if (snake.direction !== "down")
                snake.direction = "up"
            break
        case Qt.Key_A:
            if (snake.direction !== "right")
                snake.direction = "left"
            break
        case Qt.Key_S:
            if (snake.direction !== "up")
                snake.direction = "down"
            break
        case Qt.Key_D:
            if (snake.direction !== "left")
                snake.direction = "right"
            break
        }
        event.accepted = true
    }

    function startGame() {
        snake.startMove()
    }

    function randomlyGenerateFood(foodComponent) {
        for (var i = 0; i < 10; i++) {
            let x = Math.floor(Math.random() * size)
            let y = Math.floor(Math.random() * size)
            if (!board[y][x]) {
                board[y][x] = foodComponent.createObject(canvas, {
                                                             "atomSize": atomSize,
                                                             "x": x * atomSize,
                                                             "y": y * atomSize
                                                         })
                break
            }
        }
    }

    Component.onCompleted: {
        // createSnake
        snakeComponent = Qt.createComponent("Snake.qml")
        board = new Array(canvas.height / atomSize)
        for (var i = 0; i < size; i++) {
            board[i] = new Array(size)
        }
        snake = snakeComponent.createObject(canvas, {
                                                "direction": "right",
                                                "atomSize": atomSize,
                                                "color": 'orange',
                                                "gameBoard": gameBoard
                                            })

        // create plus one life food
        plusLifeComponent = Qt.createComponent("PlusLife.qml")
        for (i = 0; i < plusLifeNum; i++) {
            randomlyGenerateFood(plusLifeComponent)
        }
        // create Accelerate food
        accelerateComponent = Qt.createComponent("Accelerate.qml")
        for (i = 0; i < acclerateNum; i++) {
            randomlyGenerateFood(accelerateComponent)
        }

        // createFood
        foodComponent = Qt.createComponent("Food.qml")
        for (i = 0; i < foodNumber; i++) {
            randomlyGenerateFood(foodComponent)
        }
    }
}
