import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Shapes 1.12

Item {
    id: accelerate
    property int atomSize: 30
    width: atomSize
    height: atomSize
    property var gameBoard
    RectangularGlow {
        id: effect
        anchors.fill: rect
        glowRadius: 5
        spread: 0.2
        color: rect.border.color
        cornerRadius: rect.radius + glowRadius
    }
    Rectangle {
        id: rect
        border.color: 'green'
        color: "#212121"
        anchors.centerIn: parent
        radius: 5
        width: accelerate.atomSize * 0.8
        height: width
        Shape {
            id: triangle1
            x: 5
            y: 6
            opacity: 0
            ShapePath {
                strokeWidth: 1
                strokeColor: "green"
                fillColor: 'green'
                startX: 0
                startY: 0
                PathLine {
                    x: 4
                    y: 6
                }
                PathLine {
                    x: 0
                    y: 12
                }
                PathLine {
                    x: 0
                    y: 5
                }
                PathLine {
                    x: 0
                    y: 0
                }
            }
        }
        Shape {
            id: triangle2
            x: 10
            y: 6
            opacity: 0
            ShapePath {
                strokeWidth: 1
                strokeColor: "green"
                fillColor: 'green'
                startX: 0
                startY: 0
                PathLine {
                    x: 4
                    y: 6
                }
                PathLine {
                    x: 0
                    y: 12
                }
                PathLine {
                    x: 0
                    y: 5
                }
                PathLine {
                    x: 0
                    y: 0
                }
            }
        }
        Shape {
            id: triangle3
            x: 15
            y: 6
            opacity: 0
            ShapePath {
                strokeWidth: 1
                strokeColor: "green"
                fillColor: 'green'
                startX: 0
                startY: 0
                PathLine {
                    x: 4
                    y: 6
                }
                PathLine {
                    x: 0
                    y: 12
                }
                PathLine {
                    x: 0
                    y: 5
                }
                PathLine {
                    x: 0
                    y: 0
                }
            }
        }

        SequentialAnimation {
            loops: Animation.Infinite
            running: true
            NumberAnimation {
                target: triangle1
                property: "opacity"
                from: 0
                to: 0.9
                duration: 300
            }
            NumberAnimation {
                target: triangle2
                property: "opacity"
                from: 0
                to: 0.9
                duration: 300
            }
            NumberAnimation {
                target: triangle3
                property: "opacity"
                from: 0
                to: 0.9
                duration: 300
            }

            NumberAnimation {
                targets: [triangle1, triangle2, triangle3]
                properties: "opacity"
                duration: 500
                from: 1
                to: 0
            }
        }
    }

    // drag
    property point beginPos
    property bool caught: false
    property bool dragEnabled: false
    Drag.active: dragArea.drag.active
    MouseArea {
        id: dragArea
        enabled: dragEnabled
        anchors.fill: parent
        drag.target: parent
        onPressed: {
            caught = false
            beginPos = Qt.point(accelerate.x, accelerate.y)
        }
        onReleased: {
            if (!accelerate.caught) {
                backAnimX.to = beginPos.x
                backAnimY.to = beginPos.y
                backAnim.start()
            } else {
                gameBoard.board[Math.floor(
                                    beginPos.y / atomSize)][Math.floor(
                                                                beginPos.x / atomSize)] = null
                accelerate.x -= accelerate.x % atomSize
                accelerate.y -= accelerate.y % atomSize
                gameBoard.board[accelerate.y / atomSize][accelerate.x / atomSize] = accelerate
            }
        }
    }
    ParallelAnimation {
        id: backAnim
        SpringAnimation {
            id: backAnimX
            target: accelerate
            property: "x"
            duration: 500
            spring: 2
            damping: 0.2
        }
        SpringAnimation {
            id: backAnimY
            target: accelerate
            property: "y"
            duration: 500
            spring: 2
            damping: 0.2
        }
    }
}
