import QtQuick 2.0
import QtGraphicalEffects 1.0
import Material 0.2
import Material.ListItems 0.1 as ListItem

Item {
    property int frequency: 500
    width: circle.width
    height: width
    z: 150

    onFrequencyChanged: {
        anim.stop()
        down.duration = frequency
        up.duration = frequency
        anim.start()
    }

    Icon {
        id: circle
        size: 35
        name: "shape/circle"
        color: "white"
    }
    Glow {
        id: glow
        anchors.fill: circle
        samples: 50
        radius: Math.floor(samples/2)
        color: "#999999"
        source: circle

        SequentialAnimation on samples {
            id: anim
            running: true
            loops: Animation.Infinite
            NumberAnimation {
                id: down
                from: 40
                to: 15
                duration: frequency
            }
            NumberAnimation {
                id: up
                from: 15
                to: 40
                duration: frequency
            }
        }
    }
}
