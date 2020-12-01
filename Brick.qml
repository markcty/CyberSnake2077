import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id: brick
    property real atomSize: 30
    width: atomSize
    height: atomSize
    property var gameBoard
    Text {
        id: text
        anchors.centerIn: brick
        text: "X"
        font.family: "Helvetica"
        font.pointSize: brick.atomSize * 0.8
        color: "#9a031e"
    }
    Glow {
        anchors.fill: text
        radius: 5
        samples: 17
        color: "#9a031e"
        source: text
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
            beginPos = Qt.point(brick.x, brick.y)
        }
        onReleased: {
            if (!brick.caught) {
                backAnimX.to = beginPos.x
                backAnimY.to = beginPos.y
                backAnim.start()
            } else {
                gameBoard.board[Math.floor(
                                    beginPos.y / atomSize)][Math.floor(
                                                                beginPos.x / atomSize)] = null
                brick.x -= brick.x % atomSize
                brick.y -= brick.y % atomSize
                gameBoard.board[brick.y / atomSize][brick.x / atomSize] = brick
            }
        }
    }
    ParallelAnimation {
        id: backAnim
        SpringAnimation {
            id: backAnimX
            target: brick
            property: "x"
            duration: 500
            spring: 2
            damping: 0.2
        }
        SpringAnimation {
            id: backAnimY
            target: brick
            property: "y"
            duration: 500
            spring: 2
            damping: 0.2
        }
    }
}
