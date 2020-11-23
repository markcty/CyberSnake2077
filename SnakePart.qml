import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    RectangularGlow {
        id: effect
        anchors.fill: part
        spread: 0.55
        color: "#2e91ed"
        cornerRadius: part.radius + glowRadius
        SequentialAnimation on glowRadius {
            NumberAnimation {
                from: -5
                to: 6
                easing {
                    type: Easing.OutQuint
                }

                duration: 500
            }
            NumberAnimation {
                from: 6
                to: -5
                duration: 3000
            }
        }
    }
    Rectangle {
        id: part
        width: 25
        height: 25
        radius: 12.5
        color: "#212121"
        border {
            color: '#2e91ed'
            width: 1
        }
        x: 2.5
        y: 2.5
    }
}
