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
}
