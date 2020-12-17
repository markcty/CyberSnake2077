import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

MapItem {
    id: food
    property string name: "food"
    property var foodNames: ["/assets/apple.svg", "/assets/cherry.svg", "/assets/tomato.svg", "/assets/watermelon.svg"]
    Image {
        id: foodImage
        width: food.atomSize * 0.8
        height: food.atomSize * 0.8
        anchors.centerIn: food
        source: food.foodNames[(Math.floor(Math.random() * 100)) % 4]
        smooth: true
    }
}
