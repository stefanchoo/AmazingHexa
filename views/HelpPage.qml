import QtQuick 2.0
import QtQuick.Controls 2.2
import Material 0.2
import Material.ListItems 0.1 as ListItem

Item {
    id: root
    width: 1200
    height: 800
    z: 200

    focus: screen.state !== "running"

    Keys.onReturnPressed: startBtn.click()

    property alias startButton: startBtn
    property alias finishButton: finishBtn

    Hexagonal {
        anchors.fill: parent
        boardSize: 1000
        hAngle: 30
        color: "#444444"
    }

    Label {
        anchors {
            top: parent.top
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        text: "六角拼图"
        color: "white"
        style: "display1"
    }

    Item {
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.2
        width: parent.width * 0.3
        height: parent.height
        Hexagonal {
            id: target
            y: 100
            anchors.horizontalCenter: parent.horizontalCenter
            boardSize: 100
            point: [0, 0]
            color: "#666666"
        }

        EndEffect {
            id: end
            y: 370
            anchors.horizontalCenter: parent.horizontalCenter
            state: y == 620 ? "graspState" : y == 120 ? "putState" : "moveState"
            bColor: color.visible ? "orange" : "#03A9F4"
        }

        Hexagonal {
            id: base
            y: 610
            anchors.horizontalCenter: parent.horizontalCenter
            boardSize: 80
            point: [0, 0]
            color: "#222222"
        }

        Rectangle {
            id: color
            y: 620
            width: 60
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            radius: width / 2
            color: "orange"
            visible: false
        }

        Label {
            id: operationInfo
            anchors.centerIn: parent
            text: "1. 选形状"
            color: "white"
            style: "headline"
        }
    }

    Item {
        width: parent.width * 0.4
        height: parent.height
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.15
        GameButton {
            id: startBtn
            text: "开始游戏"
            anchors {
                top: parent.top
                topMargin: 260
                horizontalCenter: parent.horizontalCenter
            }
            onClick: {
                if (screen.state == "pause")
                    screen.continued()
                else
                    screen.started()
            }
        }

        GameButton {
            id: finishBtn
            text: "结束游戏"
            enabled: screen.state === "pause"
            anchors {
                bottom: parent.bottom
                bottomMargin: 260
                horizontalCenter: parent.horizontalCenter
            }
            onClick: screen.finished()
        }
    }

    SequentialAnimation {
        running: true
        loops: Animation.Infinite
        NumberAnimation {
            target: end
            property: "y"
            to: 620
            duration: 1000
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            duration: 2000
        }
        ParallelAnimation {
            NumberAnimation {
                target: end
                property: "value"
                to: 100
            }
            NumberAnimation {
                target: base
                property: "boardSize"
                to: 100
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: base
                property: "y"
                to: 600
                easing.type: Easing.InOutQuad
            }
            PropertyAnimation {
                target: operationInfo
                property: "text"
                to: "2. 拼 图"
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: base
                property: "y"
                to: 100
                duration: 1000
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: end
                property: "y"
                to: 120
                duration: 1000
                easing.type: Easing.InOutQuad
            }
        }
        NumberAnimation {
            //暂停作用
            duration: 2000
        }

        ParallelAnimation {
            PropertyAnimation {
                target: color
                property: "visible"
                to: true
            }
            NumberAnimation {
                target: end
                property: "value"
                to: 0
            }
            PropertyAnimation {
                target: operationInfo
                property: "text"
                to: "3. 选颜色"
            }
        }

        NumberAnimation {
            target: end
            property: "y"
            to: 620
            duration: 1000
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            //暂停作用
            duration: 2000
        }
        PropertyAnimation {
            target: operationInfo
            property: "text"
            to: "4. 涂 色"
        }
        NumberAnimation {
            target: end
            property: "value"
            to: 100
        }
        NumberAnimation {
            target: end
            property: "y"
            to: 120
            duration: 1000
        }
        NumberAnimation {
            //暂停作用
            duration: 2000
        }
        ParallelAnimation {
            PropertyAnimation {
                target: base
                property: "color"
                to: "orange"
            }
            PropertyAnimation {
                target: color
                property: "visible"
                to: true
            }
            NumberAnimation {
                target: end
                property: "value"
                to: 0
            }
            NumberAnimation {
                target: end
                property: "value"
                to: 0
            }
            PropertyAnimation {
                target: operationInfo
                property: "text"
                to: "5. 完 成"
            }
        }
        NumberAnimation {
            //暂停作用
            duration: 2000
        }

        ParallelAnimation {

            PropertyAnimation {
                target: color
                property: "visible"
                to: false
                duration: 1
            }
            PropertyAnimation {
                target: base
                property: "color"
                to: "#222222"
                duration: 1
            }
            NumberAnimation {
                target: base
                property: "boardSize"
                to: 80
                easing.type: Easing.InOutQuad
                duration: 1
            }
            NumberAnimation {
                target: base
                property: "y"
                to: 610
                easing.type: Easing.InOutQuad
                duration: 1
            }

            NumberAnimation {
                target: end
                property: "y"
                to: 370
                duration: 1
                easing.type: Easing.InOutQuad
            }
            PropertyAnimation {
                target: operationInfo
                property: "text"
                to: "1. 选形状"
            }
        }
    }
}
