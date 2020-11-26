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
    property real atomSize: 30
    property color color
    property var board
    property int lifes: 3

    signal finishMove(var snake)

    Component.onCompleted: {
        snakePartComponent = Qt.createComponent("SnakePart.qml")
        snakeParts = []
        for (var x = atomSize; x <= 5 * atomSize; x += atomSize) {
            snakeParts.push(snakePartComponent.createObject(snake, {
                                                                "x": x,
                                                                "y": atomSize,
                                                                "atomSize": atomSize,
                                                                "color": snake.color,
                                                                "partSize": atomSize * 4 / 5
                                                            }))
        }
        for (var i = 0; i < 3; i++) {
            snakeParts[i].partSize = atomSize * (i + 5) / 10
        }
    }

    function move() {
        // delete the tail
        var tail = snakeParts.shift()
        tail.startDestroy()
        var j = tail.x / atomSize, i = tail.y / atomSize
        board[i][j] = null
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
        if (i < 0 || i >= board.length || j < 0 || j >= board.length) {
            snake.destroy()
            return
        }
        // to-do: detect collision with other items
        if (board[i][j]) {
            console.log(board[i][j].name)
            if (board[i][j] instanceof PlusLife) {
                snake.lifes++
                board[i][j].destroy()
            }
        }
        // create head
        snakeParts.push(snakePartComponent.createObject(snake, {
                                                            "x": nextX,
                                                            "y": nextY,
                                                            "atomSize": atomSize,
                                                            "color": snake.color,
                                                            "partSize": atomSize * 4 / 5
                                                        }))
        // make tail look smaller
        for (i = 0; i < 3; i++) {
            snakeParts[i].partSize = atomSize * (i + 5) / 10
        }
        snake.finishMove(snake)
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
}
