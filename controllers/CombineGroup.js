.import QtQuick 2.0 as Quick
.import "Combine.js" as Combine

var combineObjects = [];

function createCombineGroup(view, combineGroup) {
    var component = Qt.createComponent("../views/CombineGroup.qml")
    if (component.status === Quick.Component.Ready) {
        var combineGroupObject = component.createObject(view)
        if (combineGroupObject === null) {
            console.log("error creating CombineGroup");
            console.log(component.errorString());
            return null;
        }
        combineGroupObject.width = combineGroup.width;
        combineGroupObject.height = combineGroup.height;
        combineGroupObject.x = combineGroup.x;
        combineGroupObject.y = combineGroup.y;
        combineGroupObject.size = combineGroup.size;
        combineGroupObject.color = combineGroup.color;
        combineGroupObject.groupList = combineGroup.groupList;
        drawCombineGroup(view, combineGroupObject);
    } else {
        console.log("error loading CombineGroup component")
        console.log(component.errorString())
        return null;
    }
    return combineGroupObject;
}

// 创建形状组
function drawCombineGroup(view, combineGroupObj) {
    combineObjects = [];
    // 这里会创建三个
    for(var i=0; i<combineGroupObj.groupList.length; i++) {
        var combine = Object;
        combine.x = combineGroupObj.x + Math.round((i % 3) * combineGroupObj.width / 3);
        combine.y = combineGroupObj.y;
        combine.width = Number(combineGroupObj.width / 3);
        combine.height = combineGroupObj.height;
        combine.bSize = combineGroupObj.size;
        combine.fSize = combineGroupObj.size + 2;
        combine.inGraph = false;
        combine.combineColor = combineGroupObj.color;
        combine.pointList = combineGroupObj.groupList[i];
        if(i > 2) combine.visible = false;
        combineObjects.push(Combine.createCombine(view, combine));
    }
    return combineObjects;
}

// 获取当前抓取点
function getCurrentGraspPoint(combineGroupObj) {
    var temp_x = combineGroupObj.x + combineGroupObj.width * (1 + 2 * combineGroupObj.curIndex) / 6;
    var temp_y = combineGroupObj.y + combineGroupObj.height * 0.5;
    return [Number(temp_x), Number(temp_y)]
}
