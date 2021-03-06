import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

MapItem {
    id: plusLife
    property string name: "plusLife"
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
}
