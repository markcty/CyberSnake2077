import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    id: snake
    anchors.fill: parent
    property string name: "snake"

    property var snakeBody: []
    property var snakeBodyComponent
    property string direction
    property var inputStack: []
    property real atomSize: 26
    property color color
    property var gameBoard
    property int lifes: 3
    property int defaultLength: 5
    property bool autoMove: true

    Component.onCompleted: {
        snakeBodyComponent = Qt.createComponent("SnakeBody.qml")
        createSnake()
    }

    function move() {
        var i, j, longer
        // change direction
        if (autoMove) {
            autoChangeDirection()
        } else if (inputStack.length) {
            let nextDirection = inputStack.shift()
            switch (direction) {
            case "up":
                if (nextDirection !== "down")
                    direction = nextDirection
                break
            case "left":
                if (nextDirection !== "right")
                    direction = nextDirection
                break
            case "right":
                if (nextDirection !== "left")
                    direction = nextDirection
                break
            case "down":
                if (nextDirection !== "up")
                    direction = nextDirection
                break
            }
        }
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
            if (next.name === "plusLife") {
                snake.lifes++
                next.destroy()
                gameBoard.board[i][j] = null
                gameBoard.randomlyGenerateItem(gameBoard.plusLifeComponent)
            } // detect brick
            else if (next.name === "brick") {
                rebirth()
                return
            } // detect normal food
            else if (next.name === "food") {
                longer = true
                next.destroy()
                gameBoard.board[i][j] = null
                gameBoard.randomlyGenerateItem(gameBoard.foodComponent)
                moveTimer.speed -= 20
            } // detect accelrate food
            else if (next.name === "accelerate") {
                moveTimer.accelerate()
                next.destroy()
                gameBoard.board[i][j] = null
                gameBoard.randomlyGenerateItem(gameBoard.accelerateComponent)
            } // detect color allergy food
            else if (next.name === "colorAllergy") {
                next.destroy()
                gameBoard.board[i][j] = null
                gameBoard.randomlyGenerateItem(gameBoard.colorAllergyComponent)
                if (snake.color !== next.color) {
                    rebirth()
                    return
                } else
                    longer = true
            } // detect other snake
            else if (next.name === "snake") {
                next.rebirth()
                // eat the snake itself
                if (next === snake)
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
        snakeBody.push(snakeBodyComponent.createObject(snake, {
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

    function autoChangeDirection() {
        let board = gameBoard.board
        let size = board.length
        // search the nearest food
        let curJ = snakeBody[snakeBody.length - 1].x / atomSize
        let curI = snakeBody[snakeBody.length - 1].y / atomSize

        function isFood(item) {
            if (!item)
                return false
            if (item.name === "accelerate" || item.name === "food"
                    || item.name === "plusLife"
                    || (item.name === "colorAllergy"
                        && item.color === snake.color))
                return true
            return false
        }
        function findNearestFood() {
            var i, j, k
            for (k = 1; k < size; k++) {
                // up
                if (curI - k > 0) {
                    for (j = curJ - k; j <= curJ + k; j++)
                        if (j >= 0 && j < size && isFood(board[curI - k][j]))
                            return {
                                "i": curI - k,
                                "j": j
                            }
                }
                // left
                if (curJ - k > 0) {
                    for (i = curI - k; i <= curI + k; i++)
                        if (i >= 0 && i < size && isFood(board[i][curJ - k]))
                            return {
                                "i": i,
                                "j": curJ - k
                            }
                }
                // down
                if (curI + k < size) {
                    for (j = curJ - k; j <= curJ + k; j++)
                        if (j >= 0 && j < size && isFood(board[curI + k][j]))
                            return {
                                "i": curI + k,
                                "j": j
                            }
                }
                // right
                if (curJ + k < size) {
                    for (i = curI - k; i <= curI + k; i++)
                        if (i >= 0 && i < size && isFood(board[i][curJ + k]))
                            return {
                                "i": i,
                                "j": curJ + k
                            }
                }
            }
        }
        function distance(i0, j0, i1, j1) {
            return Math.abs(i0 - i1) + Math.abs(j0 - j1)
        }

        var nearestFood = findNearestFood()
        // return the score of position <i,j>
        function tryPos(i, j) {
            // out of border
            if (i < 0 || i >= size || j < 0 || j >= size)
                return -1
            let item = board[i][j], score = 0
            if (item) {
                // smash to brick
                if (item.name === "brick" || (item.name === "colorAllergy"
                                              && item.color !== snake.color))
                    return -1
                // smash to itself
                if (item === snake)
                    return -1
                // food
                score += 8
            }
            // if the next move brings food closer then score + 5
            if (distance(curI, curJ, nearestFood.i,
                         nearestFood.j) > distance(i, j, nearestFood.i,
                                                   nearestFood.j))
                score += 5
            else
                score += 3
            // if the next move can kill another snake
            if (item && item.name === "snake")
                score += 10
            return score
        }
        let min = -2, score, nextDirection
        // left
        if (direction !== "right") {
            score = tryPos(curI, curJ - 1)
            if (score > min) {
                nextDirection = "left"
                min = score
            }
        }
        // right
        if (direction !== "left") {
            score = tryPos(curI, curJ + 1)
            if (score > min) {
                nextDirection = "right"
                min = score
            }
        }
        // up
        if (direction !== "down") {
            score = tryPos(curI - 1, curJ)
            if (score > min) {
                nextDirection = "up"
                min = score
            }
        }
        // down
        if (direction !== "up") {
            score = tryPos(curI + 1, curJ)
            if (score > min) {
                nextDirection = "down"
                min = score
            }
        }
        direction = nextDirection
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
        for (var x = 0; x < defaultLength; x++) {
            snakeBody.push(snakeBodyComponent.createObject(snake, {
                                                               "x": (initJ + x) * atomSize,
                                                               "y": initI * atomSize,
                                                               "atomSize": atomSize,
                                                               "color": snake.color,
                                                               "partSize": atomSize * 4 / 5
                                                           }))
            gameBoard.board[initI][initJ + x] = snake
            let t = initJ + x
        }
        // alter the size
        var size = 0.3, delta = (0.8 - 0.3) / snakeBody.length
        for (i = 0; i < snakeBody.length; i++) {
            snakeBody[i].partSize = atomSize * (size + delta * i)
        }
    }

    function startMove() {
        inputStack = []
        moveTimer.start()
    }

    function stopMove() {
        moveTimer.stop()
    }

    function rebirth() {
        // start animation
        rebirthAnimation.start()
        // clear the board
        if (!--lifes)
            snake.destroy()
        for (var i = 0; i < snakeBody.length; i++) {
            gameBoard.board[snakeBody[i].y / atomSize][snakeBody[i].x / atomSize] = null
            snakeBody[i].startDestroy()
        }
        // init the new snake
        inputStack = []
        createSnake()
        direction = "right"
        moveTimer.stop()
        acclerateTimer.stop()
        moveTimer.speed = 400
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
            if (speed < 200)
                speed = 100
            if (!acclerateTimer.running) {
                interval = speed
            }
        }
        function accelerate() {
            interval = speed / 1.5
            acclerateTimer.restart()
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

    SequentialAnimation {
        id: rebirthAnimation
        running: false
        loops: 3
        NumberAnimation {
            target: snake
            property: "opacity"
            duration: 500
            from: 1
            to: 0
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: snake
            property: "opacity"
            duration: 500
            from: 0
            to: 1
            easing.type: Easing.InOutQuad
        }
        onRunningChanged: {
            if (gameBoard.running)
                snake.startMove()
        }
    }
}
