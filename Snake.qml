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

    Component.onCompleted: {
        snakePartComponent = Qt.createComponent("SnakePart.qml")
        snakeParts = []
        for (var x = atomSize; x <= 4 * atomSize; x += atomSize) {
            snakeParts.push(snakePartComponent.createObject(snake, {
                                                                "x": x,
                                                                "y": atomSize,
                                                                "atomSize": atomSize,
                                                                "color": snake.color,
                                                                "partSize": atomSize * 4 / 5
                                                            }))
            gameBoard.board[1][x / atomSize] = snake
        }
        for (var i = 0; i < 3; i++) {
            snakeParts[i].partSize = atomSize * (i + 5) / 10
        }
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
        if (gameBoard.board[i][j]) {
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
        // create head
        snakeParts.push(snakePartComponent.createObject(snake, {
                                                            "x": nextX,
                                                            "y": nextY,
                                                            "atomSize": atomSize,
                                                            "color": snake.color,
                                                            "partSize": atomSize * 4 / 5
                                                        }))
        gameBoard.board[nextY / atomSize][nextX / atomSize] = snake
        // make tail look smaller
        for (i = 0; i < 3; i++) {
            snakeParts[i].partSize = atomSize * (i + 5) / 10
        }
    }

    function startMove() {
        moveTimer.start()
    }

    function getHead() {
        return {
            "x": snakeParts[snakeParts.length - 1].x,
            "y": snakeParts[snakeParts.length - 1].y
        }
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
