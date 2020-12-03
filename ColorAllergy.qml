import QtQuick 2.12
import QtGraphicalEffects 1.0

MapItem {
    id: colorAllergy
    property var colors: ['orange', '#2e91ed']
    property string name: "colorAllergy"
    property color color: colors[Math.floor(Math.random() * 2)]
    RadialGradient {
        id: gradient
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: colorAllergy.color
            }
            GradientStop {
                position: 0.5
                color: "#212121"
            }
        }
        SequentialAnimation on opacity {
            loops: Animation.Infinite

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
}
