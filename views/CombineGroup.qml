import QtQuick 2.0

Item {
    id: group
    width: 900
    height: 250
    property var groupList: []     // 三组Combine的数据
    property int size: 50
    property string color: "white"
    property int curIndex: 0

//    Row {
//        id: row
//        Repeater {
//            model: groupList
//            delegate: Item {
//                id: wrapper
//                width: group.width / 3
//                height: group.height
//                Combine {
//                    id: combine
//                    anchors.centerIn: wrapper
//                    pointList: groupList[index]
//                }
//            }
//        }
//    }

}
