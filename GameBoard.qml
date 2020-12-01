import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id: gameBoard
    width: 900
    height: width
    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    property real atomSize: 30
    property var snakes: []
    property var snakeComponent
    property var board
    property int size: canvas.height / atomSize
    property var plusLifeComponent
    property var accelerateComponent
    property var foodComponent
    property var brickComponent
    property int plusLifeNum: 2
    property int acclerateNum: 2
    property int foodNumber: 5
    property int brickNumber: 8
    property int players: 1
    property bool running: true
    property bool editMode: false
    readonly property var snakeColor: ['orange', '#2e91ed']

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
        width: 810
        height: 810
        color: '#212121'
        radius: 20
        anchors.centerIn: parent
    }

    Keys.onPressed: {
        // to-do: user input stack
        if (snakes[0]) {
            switch (event.key) {
            case Qt.Key_W:
                if (snakes[0].direction !== "down")
                    snakes[0].direction = "up"
                break
            case Qt.Key_A:
                if (snakes[0].direction !== "right")
                    snakes[0].direction = "left"
                break
            case Qt.Key_S:
                if (snakes[0].direction !== "up")
                    snakes[0].direction = "down"
                break
            case Qt.Key_D:
                if (snakes[0].direction !== "left")
                    snakes[0].direction = "right"
                break
            }
        }
        if (snakes[1]) {
            switch (event.key) {
            case Qt.Key_I:
                if (snakes[1].direction !== "down")
                    snakes[1].direction = "up"
                break
            case Qt.Key_J:
                if (snakes[1].direction !== "right")
                    snakes[1].direction = "left"
                break
            case Qt.Key_K:
                if (snakes[1].direction !== "up")
                    snakes[1].direction = "down"
                break
            case Qt.Key_L:
                if (snakes[1].direction !== "left")
                    snakes[1].direction = "right"
                break
            }
        }
        event.accepted = true
    }

    function startGame() {
        initBoard()
        for (var i = 0; i < snakes.length; i++)
            snakes[i].startMove()
    }

    function randomlyGenerateItem(foodComponent) {
        for (var i = 0; i < 10; i++) {
            let x = Math.floor(Math.random() * size)
            let y = Math.floor(Math.random() * size)
            if (!board[y][x]) {
                board[y][x] = foodComponent.createObject(canvas, {
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

    function initBoard() {
        var i, j
        // init the board
        if (board) {
            for (i = 0; i < size; i++) {
                for (j = 0; j < size; j++)
                    if (board[i][j] && board[i][j].destroy)
                        board[i][j].destroy()
            }
        }
        board = new Array(canvas.height / atomSize)
        for (i = 0; i < size; i++) {
            board[i] = new Array(size)
            for (j = 0; j < size; j++)
                board[i][j] = null
        }
        // create snakes
        snakeComponent = Qt.createComponent("Snake.qml")
        for (i = 0; i < players; i++) {
            snakes[i] = snakeComponent.createObject(canvas, {
                                                        "direction": "right",
                                                        "atomSize": atomSize,
                                                        "color": snakeColor[i],
                                                        "gameBoard": gameBoard
                                                    })
        }
        // create plus one life food
        plusLifeComponent = Qt.createComponent("PlusLife.qml")
        for (i = 0; i < plusLifeNum; i++) {
            randomlyGenerateItem(plusLifeComponent)
        }
        // create Accelerate food
        accelerateComponent = Qt.createComponent("Accelerate.qml")
        for (i = 0; i < acclerateNum; i++) {
            randomlyGenerateItem(accelerateComponent)
        }
        // create normal food
        foodComponent = Qt.createComponent("Food.qml")
        for (i = 0; i < foodNumber; i++) {
            randomlyGenerateItem(foodComponent)
        }
        // generate bricks
        brickComponent = Qt.createComponent("Brick.qml")
        for (i = 0; i < brickNumber; i++) {
            randomlyGenerateItem(brickComponent)
        }
    }
    onRunningChanged: {
        for (var i = 0; i < players; i++) {
            if (running) {
                snakes[i].startMove()
                focus = true
            } else
                snakes[i].stopMove()
        }
    }
    onEditModeChanged: {
        for (var i = 0; i < size; i++)
            for (var j = 0; j < size; j++) {
                if (!board[i][j])
                    continue
                if (board[i][j] instanceof Food
                        || board[i][j] instanceof Accelerate
                        || board[i][j] instanceof PlusLife
                        || board[i][j] instanceof Brick) {
                    board[i][j].dragEnabled = editMode
                }
            }
    }
}
