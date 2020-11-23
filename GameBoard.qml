import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id: gameBoard
    width: 800
    height: 800
    property int atomSize: 30
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

    Timer {
        running: true
        repeat: true
        interval: 500
        onTriggered: {
            snake.move()
        }
    }

    Component.onCompleted: {
        snakeComponent = Qt.createComponent("Snake.qml")
        snake = snakeComponent.createObject(canvas)
    }
}
