import QtQuick 2.0
import "../controllers/Combine.js" as Control

Item {
    id: combine
    width: 250
    height: 250
    property bool inGraph: false
    property string combineColor: "white"
    property int bSize: 80 // 这里得加入Hexagoal的元素
    property int fSize: bSize + 2
    property var pointList: [] // 数据源输入的点位
    property var shiftList: [] // 向中心点偏移后的点位
    property var targetPoint: [] // 目标点位，活动范围内的坐标

    Repeater {
        model: inGraph ? pointList : shiftList
        delegate: Hexagonal {
            point: inGraph ? pointList[index] : shiftList[index]
            color: combineColor
            boardSize: bSize
            fillerSize: fSize
            x: (combine.width - boardSize) * 0.5 + deltaX
            y: (combine.height - boardSize) * 0.5 + deltaY
        }
    }

    Component.onCompleted: {

    }
}
