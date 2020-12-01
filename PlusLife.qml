import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id: plusLife
    property real atomSize: 30
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
        border.color: '#e63946'
        color: "#212121"
        anchors.centerIn: parent
        radius: 5
        width: plusLife.atomSize * 0.8
        height: width
        Text {
            id: text
            anchors.centerIn: parent
            text: "+1"
            color: '#e63946'
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
            beginPos = Qt.point(plusLife.x, plusLife.y)
        }
        onReleased: {
            if (!plusLife.caught) {
                backAnimX.to = beginPos.x
                backAnimY.to = beginPos.y
                backAnim.start()
            } else {
                gameBoard.board[Math.floor(
                                    beginPos.y / atomSize)][Math.floor(
                                                                beginPos.x / atomSize)] = null
                plusLife.x -= plusLife.x % atomSize
                plusLife.y -= plusLife.y % atomSize
                gameBoard.board[plusLife.y / atomSize][plusLife.x / atomSize] = plusLife
            }
        }
    }
    ParallelAnimation {
        id: backAnim
        SpringAnimation {
            id: backAnimX
            target: plusLife
            property: "x"
            duration: 500
            spring: 2
            damping: 0.2
        }
        SpringAnimation {
            id: backAnimY
            target: plusLife
            property: "y"
            duration: 500
            spring: 2
            damping: 0.2
        }
    }
}
