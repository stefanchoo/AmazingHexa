.import QtQuick 2.0 as Quick

var circleObject;

function createTargetCircle(view, point) {
   circleObject = new Object
    var circleComponent = Qt.createComponent("../views/Circle.qml");
    if (circleComponent.status === Quick.Component.Ready) {
        circleObject = circleComponent.createObject(view);
        if (!circleObject) {
            console.log("error creating endeffect");
            console.log(circleComponent.errorString());
            return null;
        }
        circleObject.x = point[0] - circleObject.width / 2;
        circleObject.y = point[1] - circleObject.height / 2;
    } else {
        console.log("error loading endeffect component");
        console.log(circleComponent.errorString());
        return null;
    }
    return circleObject;
}

