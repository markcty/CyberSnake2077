import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Window {
    visible: true
    width: 1366
    height: 768
    color: "black"
    title: qsTr("Snake Game")

    GridLayout {
        id: gridLayout
        rowSpacing: 5
        anchors.fill: parent
        columns: 2

        ColumnLayout {
            id: buttonColLayout
            Layout.preferredWidth: 300
            Layout.preferredHeight: 300
            Layout.alignment: Qt.AlignCenter

            spacing: 0

            Button {
                id: startButton
                text: "Start"
                font.pointSize: 15

                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }

            Button {
                id: quitButton
                text: "Quit"
                font.pointSize: 15

                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
        }

        ColumnLayout {
            id: canvasColLayout
            Layout.preferredWidth: 800
            Layout.preferredHeight: 768
            Layout.alignment: Qt.AlignCenter
            Canvas {
                id: canvas
                width: 600
                height: 600
                Layout.alignment: Qt.AlignCenter
                property int atomSize: 50
                onPaint: {
                    let ctx = canvas.getContext("2d")
                    ctx.clearRect(0, 0, canvas.width, canvas.height)
                    ctx.strokeStyle = '#FFFFFF'
                    ctx.lineWidth = '5'
                    ctx.strokeRect(0, 0, canvas.width, canvas.height)
                    ctx.lineWidth = '1'
                    ctx.beginPath()
                    for (var i = atomSize; i < canvas.height; i += canvas.atomSize) {
                        ctx.moveTo(0, i)
                        ctx.lineTo(canvas.width, i)
                        ctx.moveTo(i, 0)
                        ctx.lineTo(i, canvas.height)
                    }
                    ctx.stroke()
                }
            }
        }
    }
}
