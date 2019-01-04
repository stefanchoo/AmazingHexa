import QtQuick 2.5
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import QtQuick.Controls.Material 2.2


// draws two arcs (portion of a circle)
// fills the circle with a lighter secondary color
// when pressed
Canvas {
    id: canvas
    width: 60
    height: width
    antialiasing: true

    property color primaryColor: "white"
    property color secondaryColor: "blue"

    property real centerWidth: width / 2
    property real centerHeight: height / 2
    //property real radius: Math.min(canvas.width, canvas.height) / 2
    property real radius: Math.min(canvas.width - 20, canvas.height - 20) / 2

    property real minimumValue: 0
    property real maximumValue: 100
    property real currentValue: 0

    // this is the angle that splits the circle in two arcs
    // first arc is drawn from 0 radians to angle radians
    // second arc is angle radians to 2*PI radians
    property real angle: (currentValue - minimumValue) / (maximumValue - minimumValue) * 2 * Math.PI

    // we want both circle to start / end at 12 o'clock
    // without this offset we would start / end at 9 o'clock
    property real angleOffset: -Math.PI / 2

    property string action: "move" // "grasp" // "put"

    onPrimaryColorChanged: requestPaint()
    onSecondaryColorChanged: requestPaint()
    onMinimumValueChanged: requestPaint()
    onMaximumValueChanged: requestPaint()
    onCurrentValueChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d")
        ctx.save()
        ctx.clearRect(0, 0, canvas.width, canvas.height)

        // fills the mouse area when pressed
        // the fill color is a lighter version of the
        // secondary color
        timer.running = true

        // First, thinner arc
        // From angle to 2*PI
        ctx.beginPath()
        ctx.lineWidth = 10
        ctx.strokeStyle = primaryColor
        ctx.arc(canvas.centerWidth, canvas.centerHeight, canvas.radius,
                angleOffset + canvas.angle, angleOffset + 2 * Math.PI)
        ctx.stroke()

        // Second, thicker arc
        // From 0 to angle
        ctx.beginPath()
        ctx.lineWidth = 10
        ctx.strokeStyle = canvas.secondaryColor
        ctx.arc(canvas.centerWidth, canvas.centerHeight, canvas.radius,
                canvas.angleOffset, canvas.angleOffset + canvas.angle)
        ctx.stroke()

        ctx.restore()
    }

    Timer {
        id: timer
        interval: 80
        running: false
        onTriggered: {
            if(action === "grasp" && currentValue !== 100) currentValue += 5
            else if(action === "put" && currentValue !== 0) currentValue -= 5
        }
    }
}
