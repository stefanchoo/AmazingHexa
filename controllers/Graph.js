.import QtQuick 2.0 as Quick
.import "Combine.js" as Combine

var combineObjects = [];

function createGraph(view, graph) {
    var component = Qt.createComponent("../views/Graph.qml")
    if (component.status === Quick.Component.Ready) {
        var graphObject = component.createObject(view);
        if (graphObject === null) {
            console.log("error creating Graph");
            console.log(component.errorString());
            return null;
        }
        graphObject.x = graph.x;
        graphObject.y = graph.y;
        graphObject.width = graph.width;
        graphObject.height = graph.height;
        graphObject.size = graph.size;
        graphObject.color = graph.color;
        graphObject.shapeList = graph.shapeList;
        graphObject.status = graph.status;
        drawGraph(view, graphObject);
    } else {
        console.log("error loading Graph component");
        console.log(component.errorString());
        return null;
    }
    return graphObject;
}

function drawGraph(view, graphObject) {
    combineObjects = [];
    for(var i = 0; i < graphObject.shapeList.length; i++) {
        var combine = Object;
        combine.inGraph = true;
        combine.x = graphObject.x;
        combine.y = graphObject.y;
        combine.bSize = graphObject.size;
        combine.fSize = combine.bSize + 2;
        combine.combineColor = graphObject.color;
        combine.pointList = graphObject.shapeList[i];
        combine.visible = true;
        combineObjects.push(Combine.createCombine(view, combine));
    }
}

