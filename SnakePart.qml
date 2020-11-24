import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id: snakePart
    property real atomSize
    property color color
    property real partSize
    RectangularGlow {
        id: effect
        anchors.fill: part
        spread: 0.4
        color: snakePart.color
        cornerRadius: part.radius + glowRadius
        SequentialAnimation on glowRadius {
            NumberAnimation {
                from: -5
                to: 10
                easing.type: Easing.OutQuint
                duration: 200
            }
            NumberAnimation {
                from: 10
                to: -5
                duration: 1000
                easing.type: Easing.OutQuart
            }
        }
        NumberAnimation on opacity {
            from: 0
            to: 1
            duration: 1000
        }
    }
    Rectangle {
        id: part
        width: partSize
        height: width
        radius: height / 2
        color: "#212121"
        border {
            color: snakePart.color
            width: 2
        }
        x: (atomSize - partSize) / 2
        y: x
        NumberAnimation on opacity {
            from: 0.5
            to: 1
            duration: 1000
        }
    }
    function startDestroy() {
        effect.opacity = 0
        destoryAnimation.start()
    }

    NumberAnimation {
        id: destoryAnimation
        running: false
        target: part
        property: "opacity"
        from: 1
        to: 0
        duration: 300
        onRunningChanged: {
            if (running === false)
                snakePart.destroy()
        }
    }
}
