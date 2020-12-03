import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Shapes 1.12

MapItem {
    id: accelerate
    property string name: "accelerate"
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
}
