/* This script file handles the Combine logic */
.import QtQuick 2.0 as Quick
.import "Hexagoal.js" as Hexagoal

// view 为父控件， combine 为构造的赋值对象
function createCombine(view, combine) {
  var combineComponent = Qt.createComponent("../views/Combine.qml");
    if(combineComponent.status === Quick.Component.Ready) {
       var combineObject = combineComponent.createObject(view);
        if (combineObject === null) {
            console.log("error creating combine");
            console.log(combineComponent.errorString());
            return null;
        }
        combineObject.width = combine.width;
        combineObject.height = combine.height;
        combineObject.x = combine.x;
        combineObject.y = combine.y;
        combineObject.bSize = combine.bSize;
        combineObject.fSize = combine.fSize ? combine.fSize :  combineObject.bSize + 2;
        combineObject.inGraph = combine.inGraph;
        combineObject.combineColor = combine.combineColor;
        combineObject.pointList = combine.pointList;
        combineObject.visible = combine.visible;
        combineObject.shiftList = shift2Zero(combine.pointList);

    } else {
        console.log("error loading block component");
        console.log(combineComponent.errorString());
        return null;
    }
    return combineObject;
}

// 向中心点偏移
function shift2Zero(pointList) {
    var shiftList = [];
    for(var i=0; i<pointList.length; i++) {
        shiftList.push([pointList[i][0] - pointList[0][0], pointList[i][1] - pointList[0][1]]);
        console.info(shiftList[i])
    }
    return shiftList;
}


// 求解 targetPoint
// 其中 view 为 gameCanvas中的一级控件
function getAbsoluteTargetPoint(combineObj) {
    if (!combineObj.inGraph) {
        combineObj.targetPoint[0] = Math.round(combineObj.x + combineObj.width / 2);
        combineObj.targetPoint[1] = Math.round(combineObj.y + combineObj.height / 2);
    } else {
        var delta = Hexagoal.calcuOffset(combineObj.bSize, combineObj.pointList[0]);
        combineObj.targetPoint[0] = Math.round(combineObj.x + combineObj.width / 2 + delta[0]);
        combineObj.targetPoint[1] = Math.round(combineObj.y + combineObj.height / 2 + delta[1]);
    }
    return combineObj.targetPoint;
}

function getTargetPoint(combineObj) {
    if (!combineObj.inGraph) {
        combineObj.targetPoint[0] = Math.round(combineObj.width / 2);
        combineObj.targetPoint[1] = Math.round(combineObj.height / 2);
    } else {
        var delta = Hexagoal.calcuOffset(combineObj.bSize, combineObj.pointList[0]);
        combineObj.targetPoint[0] = Math.round(combineObj.width / 2 + delta[0]);
        combineObj.targetPoint[1] = Math.round(combineObj.height / 2 + delta[1]);
    }
    return combineObj.targetPoint;
}

function updateCombine(view, combineObj) {
    combineObj.visible = false;
    combineObj = createCombine(view, combineObj);
    combineObj.visible = true;
    return combineObj;
}
