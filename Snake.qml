import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    id: snake
    anchors.fill: parent

    property var snakeParts
    property var snakePartComponent
    Component.onCompleted: {
        snakePartComponent = Qt.createComponent("SnakePart.qml")
        snakeParts = []
        for (var x = 30; x <= 300; x += 30) {
            snakeParts.push(snakePartComponent.createObject(snake, {
                                                                "x": x,
                                                                "y": 30
                                                            }))
        }
    }

    function move() {
        snakeParts.shift().destroy()
        snakeParts.push(snakePartComponent.createObject(snake, {
                                                            "x": snakeParts[snakeParts.length
                                                                - 1].x + atomSize,
                                                            "y": 30
                                                        }))
    }
}
