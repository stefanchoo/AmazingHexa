import QtQuick 2.0
import QtGraphicalEffects 1.0
import Material 0.2
import Material.ListItems 0.1 as ListItem

Item {
    id: block
    width: boardSize
    height: width
    property int hAngle: 0
    property int boardSize: 80   // 边框大小
    property int fillerSize: boardSize + 2  // 填充大小
    property alias color: filler.color // 颜色
    property var point: [] // 棋盘坐标系下的左边点 (0, 0) (0, 1) (1, 0) (1, 1)
    property int deltaX: 0 // 偏移量
    property int deltaY: 0

    function calcuOffset() {
        deltaX = boardSize * (point[0] + point[1] * 0.5) * 0.5 * Math.sqrt(3);
        deltaY = boardSize * point[1] * 0.75;
    }

    Icon {
        id: filler
        anchors.centerIn: parent
        name: "shape/hexagoal"
        color: "white"
        size: fillerSize
        transform: Rotation { origin.x: filler.width / 2; origin.y: filler.height / 2; angle: hAngle }
    }

    //    Glow {
    //        anchors.fill: img
    //        radius: 5
    //        samples: 20
    //        color:  block.color//"white"
    //        source: img
    //    }

    Component.onCompleted: {
        if (point.length !== 0) calcuOffset();
        console.info("deltaX: " + deltaX + "; deltaY: " + deltaY);
    }
}
