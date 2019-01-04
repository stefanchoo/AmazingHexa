import QtQuick 2.0

Item {
    id: graph
    width: 300
    height: 300
    property var shapeList: []
    property int combineIndex: 0 //current basic shape
    property int size: 74
    property string color: "#555555"
    property string status: "waitAssemble" // "onAssemble" "assembled" "waitColor" "onColor" "colored" "finsihed"
}
