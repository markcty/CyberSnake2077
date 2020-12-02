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
                snakes[0].inputStack.push("up")
                break
            case Qt.Key_A:
                snakes[0].inputStack.push("left")
                break
            case Qt.Key_S:
                snakes[0].inputStack.push("down")
                break
            case Qt.Key_D:
                snakes[0].inputStack.push("right")
                break
            }
        }
        if (snakes[1]) {
            switch (event.key) {
            case Qt.Key_W:
                snakes[1].inputStack.push("up")
                break
            case Qt.Key_A:
                snakes[1].inputStack.push("left")
                break
            case Qt.Key_S:
                snakes[1].inputStack.push("down")
                break
            case Qt.Key_D:
                snakes[1].inputStack.push("right")
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
        for (i = 0; i < players; i++) {
            snakes[i] = snakeComponent.createObject(canvas, {
                                                        "direction": "right",
                                                        "atomSize": atomSize,
                                                        "color": snakeColor[i],
                                                        "gameBoard": gameBoard
                                                    })
        }
        // create plus one life food
        for (i = 0; i < plusLifeNum; i++) {
            randomlyGenerateItem(plusLifeComponent)
        }
        // create Accelerate food
        for (i = 0; i < acclerateNum; i++) {
            randomlyGenerateItem(accelerateComponent)
        }
        // create normal food
        for (i = 0; i < foodNumber; i++) {
            randomlyGenerateItem(foodComponent)
        }
        // generate bricks
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

    Component.onCompleted: {
        snakeComponent = Qt.createComponent("Snake.qml")
        plusLifeComponent = Qt.createComponent("PlusLife.qml")
        accelerateComponent = Qt.createComponent("Accelerate.qml")
        foodComponent = Qt.createComponent("Food.qml")
        brickComponent = Qt.createComponent("Brick.qml")
    }
}
