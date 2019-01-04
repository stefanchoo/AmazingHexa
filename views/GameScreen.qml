import QtQuick 2.4
import QtQuick.Controls 2.2
import Material 0.2
import Material.ListItems 0.1 as ListItem
import "../controllers/GameScreen.js" as GameScreen

Rectangle {
    id: root
    property int graphBlockSize: 100
    property int shapeBlockSize: 80
//    property string graphColor: "#666666"
//    property string shapeColor: "#444444"

    property string graphColor: "#555555"
    property string shapeColor: "#222222"

    property var colorGroup: ["white", "#FFC100", "#F47D29", "#BBDF7F", "#5B9CD6", "#36BFB7", "black"]
    property var colorTargetPoints: []
    property alias combineGroupComponent: shapeView
    property alias graphComponent: graphView
    property alias colorViewComponent: colorView

    property var devpointlist: []

    width: 1200
    height: 800
    radius: 10
    color: "#666666"

    View {
        id: graphView
        width: parent.width
        height: 500
        radius: 10
    }

    View {
        id: shapeView
        width: parent.width
        height: 250
        anchors {
            top: graphView.bottom
            topMargin: 50
        }
        radius: 10
    }

    View {
        id: colorView
        width: parent.width
        height: 200
        anchors {
            top: graphView.bottom
            topMargin: 50
        }
        radius: 10
        z: -100
        Row {
            Repeater {
                model: 7
                delegate: Item {
                    id: wrapper
                    width: colorView.width / 7
                    height: 200
                    Rectangle {
                        anchors.centerIn: wrapper
                        width: shapeBlockSize
                        height: width
                        radius: width / 2
                        color: colorGroup[index]
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        // 获取色板所在的目标点
        for(var i=0; i<colorGroup.length; i++) {
            var targetPoint = [];
            targetPoint[0] = Math.round(colorView.x + (1 + 2*i) * colorView.width / 14);
            targetPoint[1] = Math.round(colorView.y + colorView.height / 2);
            colorTargetPoints.push(targetPoint);
        }
    }
}
