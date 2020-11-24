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

    function check(snake) {
        var head = snake.getHead()
        console.log(head.x, head.y)
        if (head.x >= canvas.width || head.y > canvas.height || head.x < 0
                || head.y <= 0) {
            snake.destroy()
            console.log("die")
        }
    }

    Component.onCompleted: {
        snakeComponent = Qt.createComponent("Snake.qml")
        snake = snakeComponent.createObject(canvas, {
                                                "direction": "right",
                                                "atomSize": atomSize,
                                                "color": 'orange'
                                            })
        snake.finishMove.connect(check)
    }
}
