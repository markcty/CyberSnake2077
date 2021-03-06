﻿import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id: gameBoard
    anchors.fill: parent
    // defines the size of a basic element
    property real atomSize: 30
    // a two-dimension array that records all the element on board
    property var board
    // components
    property var snakeComponent
    property var plusLifeComponent
    property var accelerateComponent
    property var foodComponent
    property var brickComponent
    property var colorAllergyComponent
    // default numbers
    readonly property int plusLifeNum: 2
    readonly property int accelerateNum: 2
    readonly property int foodNum: 5
    readonly property int brickNum: 8
    readonly property int colorAllergyNum: 3
    readonly property var snakeColor: ['#03A9F4', '#FF5722', '#4CAF50', '#FFEB3B']
    // game status
    property int players: 0 // current player number
    property int aiSnakes: 0 // current ai snake number
    property bool running: false
    property bool editMode: false
    property var winner: {
        "score": 0,
        "i": 0
    }
    // private
    QtObject {
        id: internal
        property var snakes: []
        // create a snake
        // autoMove: bool -> if the snake is an ai snake
        // i: integer -> the index of the snake
        // profile: objectRef -> if profile is null the snake should birth randomly on the board
        //                       else birth on the board indicated by the profile
        function createSnake(autoMove, i, profile) {
            if (internal.snakes[i])
                return
            var scoreBoard, snakes = internal.snakes
            switch (i) {
            case 0:
                scoreBoard = score0
                break
            case 1:
                scoreBoard = score1
                break
            case 2:
                scoreBoard = score2
                break
            case 3:
                scoreBoard = score3
                break
            }
            snakes[i] = snakeComponent.createObject(canvas, {
                                                        "direction": "right",
                                                        "atomSize": atomSize,
                                                        "color": snakeColor[i],
                                                        "gameBoard": gameBoard,
                                                        "autoMove": autoMove,
                                                        "scoreBoard": scoreBoard
                                                    })
            if (profile)
                snakes[i].birthFromProfile(profile)
            else
                snakes[i].randomlyBirth()
        }
    }
    // board glow
    RectangularGlow {
        id: canvasGlow
        anchors.fill: canvas
        spread: 0.2
        glowRadius: 10
        opacity: 0
        color: "#03A9F4"
        cornerRadius: canvas.radius + glowRadius
        Behavior on color {
            ColorAnimation {
                duration: 500
            }
        }
        OpacityAnimator on opacity {
            from: 0
            to: 1
            duration: 1000
        }
    }
    Rectangle {
        id: canvas
        width: 720
        height: 720
        color: '#121416'
        radius: 20
        anchors.centerIn: parent
    }
    // scoreboards for snakes[0] & snakes[1]
    Row {
        anchors.bottom: canvas.top
        anchors.horizontalCenter: canvas.horizontalCenter
        anchors.bottomMargin: 25
        spacing: 200
        ScoreBoard {
            id: score0
            color: snakeColor[0]
            onScoreChanged: gameBoard.updateWinner(score, 0)
        }
        ScoreBoard {
            id: score1
            color: snakeColor[1]
            onScoreChanged: gameBoard.updateWinner(score, 1)
        }
    }
    // scoreboards for snakes[2] & snakes[3]
    Row {
        anchors.top: canvas.bottom
        anchors.horizontalCenter: canvas.horizontalCenter
        anchors.topMargin: 25
        spacing: 200
        ScoreBoard {
            id: score2
            color: snakeColor[2]
            onScoreChanged: gameBoard.updateWinner(score, 2)
        }
        ScoreBoard {
            id: score3
            color: snakeColor[3]
            onScoreChanged: gameBoard.updateWinner(score, 3)
        }
    }
    // handle all key input
    Keys.onPressed: {
        var snakes = internal.snakes
        function push(direction, i) {
            let l = snakes[i].inputStack.length
            if (!l || snakes[i].inputStack[l - 1] !== direction)
                snakes[i].inputStack.push(direction)
        }
        if (snakes[0] && snakes[0].name) {
            switch (event.key) {
            case Qt.Key_W:
                push("up", 0)
                break
            case Qt.Key_A:
                push("left", 0)
                break
            case Qt.Key_S:
                push("down", 0)
                break
            case Qt.Key_D:
                push("right", 0)
                break
            }
        }
        if (snakes[1] && snakes[1].name) {
            switch (event.key) {
            case Qt.Key_I:
                push("up", 1)
                break
            case Qt.Key_J:
                push("left", 1)
                break
            case Qt.Key_K:
                push("down", 1)
                break
            case Qt.Key_L:
                push("right", 1)
                break
            }
        }
        event.accepted = true
    }
    // create an object randomly on the board
    function randomlyGenerateItem(itemComponent) {
        // try 100 times to prevent infinite loop
        var size = board.length
        for (var i = 0; i < 100; i++) {
            let x = Math.floor(Math.random() * size)
            let y = Math.floor(Math.random() * size)
            if (!board[y][x]) {
                board[y][x] = itemComponent.createObject(canvas, {
                                                             "atomSize": atomSize,
                                                             "x": x * atomSize,
                                                             "y": y * atomSize,
                                                             "gameBoard": gameBoard,
                                                             "dragEnabled": gameBoard.editMode
                                                         })
                break
            }
        }
    }
    // create an object on the board indicated by i & j
    function generateItem(itemComponent, i, j) {
        board[i][j] = itemComponent.createObject(canvas, {
                                                     "atomSize": atomSize,
                                                     "x": j * atomSize,
                                                     "y": i * atomSize,
                                                     "gameBoard": gameBoard,
                                                     "dragEnabled": gameBoard.editMode
                                                 })
    }
    // generate the whole Board randomly
    function initRandomly() {
        var i
        // create snakes
        for (i = 0; i < players; i++)
            internal.createSnake(false, i, null)
        // create ai snakes
        for (i = 2; i < 2 + aiSnakes; i++)
            internal.createSnake(true, i, null)
        // create plus one life food
        for (i = 0; i < plusLifeNum; i++)
            randomlyGenerateItem(plusLifeComponent)
        // create Accelerate food
        for (i = 0; i < accelerateNum; i++)
            randomlyGenerateItem(accelerateComponent)
        // create normal food
        for (i = 0; i < foodNum; i++)
            randomlyGenerateItem(foodComponent)
        // generate bricks
        for (i = 0; i < brickNum; i++)
            randomlyGenerateItem(brickComponent)
        // generate color allergy food
        for (i = 0; i < colorAllergyNum; i++)
            randomlyGenerateItem(colorAllergyComponent)
    }
    function initFromFile() {
        var data = JSON.parse(saveGame.getRawData())
        var i
        for (i = 0; i < data.PlusLife.length; i++)
            generateItem(plusLifeComponent, data.PlusLife[i].i,
                         data.PlusLife[i].j)
        for (i = 0; i < data.Accelerate.length; i++)
            generateItem(accelerateComponent, data.Accelerate[i].i,
                         data.Accelerate[i].j)
        for (i = 0; i < data.Food.length; i++)
            generateItem(foodComponent, data.Food[i].i, data.Food[i].j)
        for (i = 0; i < data.Brick.length; i++)
            generateItem(brickComponent, data.Brick[i].i, data.Brick[i].j)
        for (i = 0; i < data.ColorAllergy.length; i++)
            generateItem(colorAllergyComponent, data.ColorAllergy[i].i,
                         data.ColorAllergy[i].j)
        for (i = 0; i < 4; i++)
            if (data.snakes[i]) {
                internal.createSnake(data.snakes[i].autoMove, i, data.snakes[i])
                if (i < 2)
                    players++
                else
                    aiSnakes++
            }
    }
    onPlayersChanged: {
        if (players <= 2)
            internal.createSnake(false, players - 1, null)
        else
            players = 2
    }
    onAiSnakesChanged: {
        if (aiSnakes <= 2)
            internal.createSnake(true, 2 + aiSnakes - 1, null)
        else
            aiSnakes = 2
    }
    // update the winner and change the canvasGlow color to the winner's color
    function updateWinner(score, i) {
        if (score > winner.score) {
            winner.score = score
            winner.i = i
            canvasGlow.color = snakeColor[winner.i]
        }
    }
    // save the game
    function save() {
        var data = {
            "PlusLife": [],
            "Accelerate": [],
            "Food": [],
            "Brick": [],
            "ColorAllergy": [],
            "snakes": []
        }
        var size = board.length
        for (var i = 0; i < size; i++)
            for (var j = 0; j < size; j++)
                if (board[i][j]) {
                    var pos = {
                        "i": i,
                        "j": j
                    }
                    switch (board[i][j].name) {
                    case "plusLife":
                        data.PlusLife.push(pos)
                        break
                    case "accelerate":
                        data.Accelerate.push(pos)
                        break
                    case "food":
                        data.Food.push(pos)
                        break
                    case "brick":
                        data.Brick.push(pos)
                        break
                    case "colorAllergy":
                        data.ColorAllergy.push(pos)
                        break
                    }
                }
        var snakes = internal.snakes
        for (i = 0; i < 4; i++) {
            if (snakes[i] && snakes[i].name) {
                data.snakes[i] = {
                    "snakeBody": [],
                    "autoMove": snakes[i].autoMove,
                    "direction": snakes[i].direction
                }
                data.snakes[i].snakeBody = snakes[i].saveSnake()
            }
        }
        saveGame.saveData(JSON.stringify(data))
    }
    onRunningChanged: {
        var snakes = internal.snakes
        for (var i = 0; i < 4; i++)
            if (snakes[i] && snakes[i].name) {
                if (running) {
                    snakes[i].startMove()
                    focus = true
                } else
                    snakes[i].stopMove()
            }
    }
    onEditModeChanged: {
        var size = board.length
        for (var i = 0; i < size; i++)
            for (var j = 0; j < size; j++) {
                if (!board[i][j])
                    continue
                if (board[i][j].name !== "snake") {
                    board[i][j].dragEnabled = editMode
                }
            }
    }
    Component.onCompleted: {
        snakeComponent = Qt.createComponent("/components/Snake.qml")
        plusLifeComponent = Qt.createComponent("/mapItems/PlusLife.qml")
        accelerateComponent = Qt.createComponent("/mapItems/Accelerate.qml")
        foodComponent = Qt.createComponent("/mapItems/Food.qml")
        brickComponent = Qt.createComponent("/mapItems/Brick.qml")
        colorAllergyComponent = Qt.createComponent("/mapItems/ColorAllergy.qml")
        // init the board array
        var i, j
        var size = canvas.height / atomSize
        board = new Array(size)
        for (i = 0; i < size; i++) {
            board[i] = new Array(size)
            for (j = 0; j < size; j++)
                board[i][j] = null
        }
    }
}
