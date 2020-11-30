import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    id: snake
    anchors.fill: parent

    property var snakeBody: []
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
        let nextX = snakeBody[snakeBody.length - 1].x + dx
        let nextY = snakeBody[snakeBody.length - 1].y + dy
        j = nextX / atomSize
        i = nextY / atomSize
        // detect collision with border
        if (i < 0 || i >= gameBoard.board.length || j < 0
                || j >= gameBoard.board.length) {
            snake.rebirth()
            return
        }
        // detect collision with other items
        var next = gameBoard.board[i][j]
        if (next) {
            // detect food-plus-one-life
            if (next instanceof PlusLife) {
                snake.lifes++
                next.destroy()
                gameBoard.board[i][j] = null
                gameBoard.randomlyGenerateItem(gameBoard.plusLifeComponent)
            } // detect accelrate food
            else if (next instanceof Accelerate) {
                moveTimer.accelerate()
                next.destroy()
                gameBoard.board[i][j] = null
                gameBoard.randomlyGenerateItem(gameBoard.accelerateComponent)
            } // detect normal food
            else if (next instanceof Food) {
                longer = true
                next.destroy()
                gameBoard.board[i][j] = null
                gameBoard.randomlyGenerateItem(gameBoard.foodComponent)
                moveTimer.speed -= 20
            } // detect other snake
            else if (next instanceof Snake) {
                next.rebirth()
                // eat the snake itself
                if (next === snake)
                    return
            } // detect brick
            else if (next instanceof Brick) {
                rebirth()
                return
            }
        }
        // delete the tail
        if (!longer) {
            var tail = snakeBody.shift()
            tail.startDestroy()
            j = tail.x / atomSize
            i = tail.y / atomSize
            gameBoard.board[i][j] = null
        }
        // create new head
        snakeBody.push(snakePartComponent.createObject(snake, {
                                                           "x": nextX,
                                                           "y": nextY,
                                                           "atomSize": atomSize,
                                                           "color": snake.color,
                                                           "partSize": atomSize * 4 / 5
                                                       }))
        gameBoard.board[nextY / atomSize][nextX / atomSize] = snake
        // adjust body size
        var size = 0.3, delta = (0.8 - 0.3) / snakeBody.length
        for (i = 0; i < snakeBody.length; i++) {
            snakeBody[i].partSize = atomSize * (size + delta * i)
        }
    }

    function createSnake() {
        snakeBody = []
        // randomly find place to generate the snake
        var boardSize = gameBoard.size, initI, initJ, i, j, tries = 10, ok = false
        while (!ok) {
            i = Math.floor(Math.random() * (boardSize - defaultLength))
            j = Math.floor(Math.random() * (boardSize - defaultLength))
            ok = true
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
        snakeBody = []
        console.log("create")
        for (var x = 0; x < defaultLength; x++) {
            snakeBody.push(snakePartComponent.createObject(snake, {
                                                               "x": (initJ + x) * atomSize,
                                                               "y": initI * atomSize,
                                                               "atomSize": atomSize,
                                                               "color": snake.color,
                                                               "partSize": atomSize * 4 / 5
                                                           }))
            gameBoard.board[initI][initJ + x] = snake
            let t = initJ + x
            console.log("create: (" + initI + "," + t + ")")
        }
        // alter the size
        var size = 0.3, delta = (0.8 - 0.3) / snakeBody.length
        for (i = 0; i < snakeBody.length; i++) {
            snakeBody[i].partSize = atomSize * (size + delta * i)
        }
    }

    function startMove() {
        moveTimer.start()
    }

    function rebirth() {
        // clear the board
        if (!--lifes)
            snake.destroy()
        console.log("rebirth")
        for (var i = 0; i < snakeBody.length; i++) {
            gameBoard.board[snakeBody[i].y / atomSize][snakeBody[i].x / atomSize] = null
            console.log("delete: (" + snakeBody[i].y / atomSize + ","
                        + snakeBody[i].x / atomSize + ")")
            snakeBody[i].startDestroy()
        }
        createSnake()
        direction = "right"
        moveTimer.interval = 400
        moveTimer.stop()
        rebirthTimer.start()
    }

    Timer {
        id: moveTimer
        repeat: true
        property real speed: 400
        interval: 400
        onTriggered: {
            snake.move()
        }
        onSpeedChanged: {
            if (speed < 100)
                speed = 100
            if (!acclerateTimer.running) {
                interval = speed
            }
        }
        function accelerate() {
            interval = speed / 1.5
            acclerateTimer.stop()
            acclerateTimer.start()
        }
    }
    Timer {
        id: acclerateTimer
        running: false
        repeat: false
        interval: 5000
        onTriggered: {
            moveTimer.interval = moveTimer.speed
        }
    }

    Timer {
        id: rebirthTimer
        running: false
        repeat: false
        interval: 3000
        onTriggered: {
            snake.startMove()
        }
    }
}
