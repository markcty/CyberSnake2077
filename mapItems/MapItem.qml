import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id: mapItem
    property real atomSize: 30
    property var gameBoard
    width: atomSize
    height: atomSize
    opacity: 0
    property point beginPos
    property bool dragEnabled: false
    Drag.active: dragArea.drag.active
    MouseArea {
        id: dragArea
        enabled: dragEnabled
        anchors.fill: parent
        drag.target: parent
        onReleased: {
            var nextX = Math.floor(mapItem.x / atomSize) * atomSize
            var nextY = Math.floor(mapItem.y / atomSize) * atomSize
            var nextI = nextY / atomSize
            var nextJ = nextX / atomSize
            if (nextI < 0 || nextJ < 0 || nextI >= gameBoard.board.length
                    || nextJ >= gameBoard.board.length) {
                // delete the object
                gameBoard.board[beginPos.y / atomSize][beginPos.x / atomSize] = null
                mapItem.destroy()
            } else if (gameBoard.board[nextI][nextJ]) {
                // back to beginning position
                backAnimX.to = beginPos.x
                backAnimY.to = beginPos.y
                backAnim.start()
            } else {
                // move to the new position
                gameBoard.board[beginPos.y / atomSize][beginPos.x / atomSize] = null
                mapItem.x = nextX
                mapItem.y = nextY
                gameBoard.board[nextI][nextJ] = mapItem
                beginPos = Qt.point(mapItem.x, mapItem.y)
            }
        }
    }
    ParallelAnimation {
        id: backAnim
        SpringAnimation {
            id: backAnimX
            target: mapItem
            property: "x"
            duration: 500
            spring: 2
            damping: 0.2
        }
        SpringAnimation {
            id: backAnimY
            target: mapItem
            property: "y"
            duration: 500
            spring: 2
            damping: 0.2
        }
    }
    Component.onCompleted: {
        beginPos = Qt.point(mapItem.x, mapItem.y)
    }
    OpacityAnimator on opacity {
        from: 0
        to: 1
        duration: 1000
    }
}
