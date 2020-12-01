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
    property point beginPos
    property bool dragEnabled: false
    Drag.active: dragArea.drag.active
    MouseArea {
        id: dragArea
        enabled: dragEnabled
        anchors.fill: parent
        drag.target: parent
        onReleased: {
            var nextX = Math.floor(plusLife.x / atomSize) * atomSize
            var nextY = Math.floor(plusLife.y / atomSize) * atomSize
            var nextI = nextY / atomSize
            var nextJ = nextX / atomSize
            if (nextI < 0 || nextJ < 0 || nextI >= gameBoard.board.length
                    || nextJ >= gameBoard.board.length) {
                backAnimX.to = beginPos.x
                backAnimY.to = beginPos.y
                backAnim.start()
            } else if (gameBoard.board[nextI][nextJ]) {
                backAnimX.to = beginPos.x
                backAnimY.to = beginPos.y
                backAnim.start()
            } else {
                console.log(beginPos.y, beginPos.x)
                gameBoard.board[beginPos.y / atomSize][beginPos.x / atomSize] = null
                plusLife.x = nextX
                plusLife.y = nextY
                gameBoard.board[nextI][nextJ] = plusLife
                beginPos = Qt.point(plusLife.x, plusLife.y)
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
    Component.onCompleted: {
        beginPos = Qt.point(plusLife.x, plusLife.y)
    }
}
