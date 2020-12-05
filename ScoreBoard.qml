import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    id: scoreBoard
    property var lifes: 3
    property int score: 0
    property color color: 'orange'
    property bool activated: false
    opacity: 0
    width: 200
    height: 30
    Row {
        Repeater {
            model: lifes
            SnakeBody {
                color: scoreBoard.color
                atomSize: 30
                partSize: atomSize * 3 / 5
            }
        }
    }
    Text {
        id: text
        text: scoreBoard.score
        font.pointSize: 20
        color: scoreBoard.color
        x: 180
        anchors.verticalCenter: parent.verticalCenter
        Behavior on x {
            NumberAnimation {
                easing.type: Easing.InOutQuad
            }
        }
    }
    OpacityAnimator on opacity {
        id: fadeIn
        from: 0
        to: 1
        duration: 1000
        running: false
    }
    onActivatedChanged: {
        if (activated)
            fadeIn.start()
        else
            text.x = 50
    }
    Behavior on score {
        NumberAnimation {
            duration: 500
        }
    }
    onLifesChanged: activated = lifes !== 0
}
