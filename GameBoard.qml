﻿import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Canvas {
    focus: true
    id: canvas
    width: 600
    height: 600
    Layout.alignment: Qt.AlignCenter
    property int atomSize: 50
    property int snakeNum: 1
    property var snakes: []

    // key handlers
    Keys.onPressed: {
        function setDirection(id, direction) {
            switch (snakes[id].direction) {
            case "up":
                if (direction !== "down")
                    snakes[id].direction = direction
                break
            case "down":
                if (direction !== "up")
                    snakes[id].direction = direction
                break
            case "right":
                if (direction !== "left")
                    snakes[id].direction = direction
                break
            case "left":
                if (direction !== "right")
                    snakes[id].direction = direction
                break
            }
        }

        switch (event.key) {
        case Qt.Key_W:
            setDirection(0, "up")
            break
        case Qt.Key_A:
            setDirection(0, "left")
            break
        case Qt.Key_S:
            setDirection(0, "down")
            break
        case Qt.Key_D:
            setDirection(0, "right")
            break
        }
    }

    function startGame() {
        for (var i = 0; i < canvas.snakeNum; i++)
            snakes[i].speed = 3
        repaintTimer.start()
        canvas.focus = true
    }

    onPaint: {
        let ctx = canvas.getContext("2d"), atomSize = canvas.atomSize
        ctx.clearRect(0, 0, canvas.width, canvas.height)
        // paint the board
        ctx.strokeStyle = '#FFFFFF'
        ctx.lineWidth = '5'
        ctx.strokeRect(0, 0, canvas.width, canvas.height)
        ctx.lineWidth = '1'
        ctx.beginPath()
        var i, j
        for (i = atomSize; i < canvas.height; i += atomSize) {
            ctx.moveTo(0, i)
            ctx.lineTo(canvas.width, i)
            ctx.moveTo(i, 0)
            ctx.lineTo(i, canvas.height)
        }
        ctx.stroke()
        // paint the snakes
        ctx.lineWidth = '10'
        for (i = 0; i < canvas.snakeNum; i++) {
            let points = canvas.snakes[i].points
            ctx.stokeStyle = snakes[i].color
            ctx.beginPath()
            ctx.moveTo(points[0].x, points[0].y)
            for (j = 1; j < points.length; j++) {
                ctx.lineTo(points[j].x, points[j].y)
            }
            ctx.stroke()
        }
    }

    // wrapper for create snake objects
    QtObject {
        id: createSnakeScript
        function createSnakeObjects(id) {
            let component = Qt.createComponent("Snake.qml")
            if (component.status === Component.Ready)
                createSnakeScript.finishCreation(id, component)
            else
                component.statusChanged.connect(
                            createSnakeScript.finishCreation)
        }
        function finishCreation(id, component) {
            let color, points, direction
            let snakeId = "snake" + id
            switch (id) {
            case 0:
                color = 'white'
                points = [{
                              "x": 175,
                              "y": 75
                          }, {
                              "x": 75,
                              "y": 75
                          }]
                direction = 'right'
                break
            }

            if (component.status === Component.Ready) {
                let snake = component.createObject(canvas, {
                                                       "id": snakeId,
                                                       "color": color,
                                                       "points": points,
                                                       "direction": direction
                                                   })
                if (snake === null) {
                    // Error Handling
                    console.log("Error creating snake")
                }
                canvas.snakes.push(snake)
            } else if (component.status === Component.Error) {
                // Error Handling
                console.log("Error loading component:", component.errorString())
            }
        }
    }

    Component.onCompleted: {
        for (var i = 0; i < canvas.snakeNum; i++)
            createSnakeScript.createSnakeObjects(i)
        canvas.requestPaint()
    }

    Timer {
        id: repaintTimer
        interval: 20
        running: false
        repeat: true
        onTriggered: {
            for (var i = 0; i < canvas.snakeNum; i++)
                snakes[i].move()
            canvas.requestPaint()
        }
    }
}
