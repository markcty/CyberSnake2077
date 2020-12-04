import QtQuick 2.12
import QtGraphicalEffects 1.0

MapItem {
    id: colorAllergy
    property var colors: ['#ff3b94', '#4CAF50', '#2e91ed', 'orange']
    property string name: "colorAllergy"
    property color color: colors[Math.floor(Math.random() * colors.length)]

    RectangularGlow {
        id: effect
        anchors.fill: rect
        glowRadius: 3
        spread: 0.2
        color: colorAllergy.color
        cornerRadius: atomSize * 0.6 + glowRadius
        SequentialAnimation on opacity {
            loops: Animation.Infinite
            running: true
            NumberAnimation {
                from: 0.5
                to: 1
                duration: 1000
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                from: 1
                to: 0.5
                duration: 1000
                easing.type: Easing.InOutQuad
            }
        }
    }

    Rectangle {
        id: rect
        anchors.centerIn: parent
        width: atomSize * 0.5
        height: atomSize * 0.5
        radius: height / 2
        color: colorAllergy.color
    }
}
