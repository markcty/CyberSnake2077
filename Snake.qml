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
    property int atomSize: 30

    Component.onCompleted: {
        snakePartComponent = Qt.createComponent("SnakePart.qml")
        snakeParts = []
        for (var x = atomSize; x <= 5 * atomSize; x += atomSize) {
            snakeParts.push(snakePartComponent.createObject(snake, {
                                                                "x": x,
                                                                "y": atomSize,
                                                                "atomSize": atomSize
                                                            }))
        }
    }

    function move() {
        snakeParts.shift().startDestroy()
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

        snakeParts.push(snakePartComponent.createObject(snake, {
                                                            "x": snakeParts[snakeParts.length
                                                                - 1].x + dx,
                                                            "y": snakeParts[snakeParts.length
                                                                - 1].y + dy,
                                                            "atomSize": atomSize
                                                        }))
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
}
