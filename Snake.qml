import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    id: snake
    anchors.fill: parent

    property var snakeParts
    property var snakePartComponent
    property string direction
    property real atomSize: 26
    property color color
    property var gameBoard
    property int lifes: 3
    property int defaultLength: 5

    Component.onCompleted: {
        snakePartComponent = Qt.createComponent("SnakePart.qml")
        createSnake()
    }

    function move() {
        var i, j, longer
        // caculate next position
        let dx = 0, dy = 0
        switch (direction) {
        case "up":
            dy = -atomSize
            break
        case "down":
            dy = atomSize
            break
        case "left":
            dx = -atomSize
            break
        case "right":
            dx = atomSize
            break
        }
        let nextX = snakeParts[snakeParts.length - 1].x + dx
        let nextY = snakeParts[snakeParts.length - 1].y + dy
        // detect collision with border
        j = nextX / atomSize
        i = nextY / atomSize
        if (i < 0 || i >= gameBoard.board.length || j < 0
                || j >= gameBoard.board.length) {
            snake.destroy()
            return
        }

        // detect collision with other items
        if (gameBoard.board[i][j] && gameBoard.board[i][j].destroy) {
            // detect food-plus-one-life
            if (gameBoard.board[i][j] instanceof PlusLife) {
                snake.lifes++
                gameBoard.board[i][j].destroy()
                gameBoard.board[i][j] = null
                gameBoard.randomlyGenerateFood(gameBoard.plusLifeComponent)
            } // detect accelrate food
            else if (gameBoard.board[i][j] instanceof Accelerate) {
                moveTimer.interval = 200
                acclerateTimer.stop()
                acclerateTimer.start()
                gameBoard.board[i][j].destroy()
                gameBoard.board[i][j] = null
                gameBoard.randomlyGenerateFood(gameBoard.accelerateComponent)
            } else if (gameBoard.board[i][j] instanceof Food) {
                longer = true
                gameBoard.board[i][j].destroy()
                gameBoard.board[i][j] = null
                gameBoard.randomlyGenerateFood(gameBoard.foodComponent)
            } else if (gameBoard.board[i][j] instanceof Snake) {
                gameBoard.board[i][j].destroy()
            }
        }
        // delete the tail
        if (!longer) {
            var tail = snakeParts.shift()
            tail.startDestroy()
            j = tail.x / atomSize
            i = tail.y / atomSize
            gameBoard.board[i][j] = null
        }
        // create new head
        snakeParts.push(snakePartComponent.createObject(snake, {
                                                            "x": nextX,
                                                            "y": nextY,
                                                            "atomSize": atomSize,
                                                            "color": snake.color,
                                                            "partSize": atomSize * 4 / 5
                                                        }))
        gameBoard.board[nextY / atomSize][nextX / atomSize] = snake
        // adjust body size
        var size = 0.3, delta = (0.8 - 0.3) / snakeParts.length
        for (i = 0; i < snakeParts.length; i++) {
            snakeParts[i].partSize = atomSize * (size + delta * i)
        }
    }

    function createSnake() {
        // find place to generate the snake
        var boardSize = gameBoard.size, initI, initJ
        for (var i = 0; i < boardSize; i++) {
            let ok = true
            for (var j = 0; j < boardSize - defaultLength; j++) {
                for (var k = 0; k < defaultLength; k++)
                    if (gameBoard.board[i][j + k]) {
                        ok = false
                        break
                    }
                if (ok) {
                    initI = i
                    initJ = j
                    break
                }
            }
            if (ok)
                break
        }
        snakeParts = []
        for (var x = initJ * atomSize; x <= defaultLength * atomSize; x += atomSize) {
            snakeParts.push(snakePartComponent.createObject(snake, {
                                                                "x": x,
                                                                "y": initI * atomSize,
                                                                "atomSize": atomSize,
                                                                "color": snake.color,
                                                                "partSize": atomSize * 4 / 5
                                                            }))
            gameBoard.board[initI][x / atomSize] = snake
        }
        var size = 0.3, delta = (0.8 - 0.3) / snakeParts.length
        for (i = 0; i < snakeParts.length; i++) {
            snakeParts[i].partSize = atomSize * (size + delta * i)
        }
    }

    function startMove() {
        moveTimer.start()
    }

    Timer {
        id: moveTimer
        repeat: true
        interval: 400
        onTriggered: {
            snake.move()
        }
    }
    Timer {
        id: acclerateTimer
        running: false
        repeat: false
        interval: 5000
        onTriggered: {
            moveTimer.interval = 400
        }
    }
}
