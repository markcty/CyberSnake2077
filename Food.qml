import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id: food
    property real atomSize: 30
    property var gameBoard
    width: atomSize
    height: atomSize
    property var foodNames: ["apple.svg", "cherry.svg", "tomato.svg", "watermelon.svg"]
    Image {
        id: foodImage
        width: food.atomSize * 0.8
        height: food.atomSize * 0.8
        anchors.centerIn: food
        source: food.foodNames[(Math.floor(Math.random() * 100)) % 4]
        smooth: true
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
            var nextX = Math.floor(food.x / atomSize) * atomSize
            var nextY = Math.floor(food.y / atomSize) * atomSize
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
                food.x = nextX
                food.y = nextY
                gameBoard.board[nextI][nextJ] = food
                beginPos = Qt.point(food.x, food.y)
            }
        }
    }
    ParallelAnimation {
        id: backAnim
        SpringAnimation {
            id: backAnimX
            target: food
            property: "x"
            duration: 500
            spring: 2
            damping: 0.2
        }
        SpringAnimation {
            id: backAnimY
            target: food
            property: "y"
            duration: 500
            spring: 2
            damping: 0.2
        }
    }
    Component.onCompleted: {
        beginPos = Qt.point(food.x, food.y)
    }
}
