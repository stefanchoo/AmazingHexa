import QtQuick 2.0
import QtQuick.Particles 2.0
import Material 0.2
import Material.ListItems 0.1 as ListItem

View {
    width: 60
    height: 60
    Timer {
        interval: 1500
        triggeredOnStart: true
        running: true
        repeat: true
        onTriggered: {
            pulseEmitter.pulse(200)
        }
    }
    ParticleSystem {
        id: particles
        anchors.fill: parent
        ImageParticle {
            source: "../images/star.png"
            alpha: 0
            colorVariation: 0.6
        }

        Emitter {
            id: pulseEmitter
            x: parent.width / 2
            y: parent.height / 2
            emitRate: 500
            lifeSpan: 1000
            enabled: false
            velocity: AngleDirection {
                magnitude: 24
                angleVariation: 360
            }
            size: 24
            sizeVariation: 8
        }
    }
}
