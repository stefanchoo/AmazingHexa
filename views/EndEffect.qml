import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: root
    width: size
    height: width
    property int size: 60
    property string bColor: "white"

    property int value: 0

    z: 150

    EndEffectAction {
        id: circle
        width: size
        secondaryColor: bColor
    }

    states: [
        State {
            name: "moveState"
            PropertyChanges {
                target: circle
                action: "move"
                currentValue: value
                opacity: 1
            }
        },

        State {
            name: "graspState"
            PropertyChanges {
                target: circle
                opacity: 1
                action: "grasp"
                currentValue: 5
            }
        },

        State {
            name: "putState"
            PropertyChanges {
                target: circle
                action: "put"
                currentValue: 95
                opacity: 1
            }
        }
    ]
}
