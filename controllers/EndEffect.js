.import QtQuick 2.0 as Quick

var endObject;

function createEndEffect(view, endEffect) {
    endObject = new Object
    var endComponent = Qt.createComponent("../views/EndEffect.qml");
    if (endComponent.status === Quick.Component.Ready) {
        endObject = endComponent.createObject(view);
        if (!endObject) {
            console.log("error creating endeffect");
            console.log(endComponent.errorString());
            return null;
        }
        endObject.x = endEffect.x;
        endObject.y = endEffect.y;
        endObject.width = endEffect.size;
        endObject.height = endEffect.size;
        endObject.bColor = endEffect.bColor;
        endObject.state = "moveState";
    } else {
        console.log("error loading endeffect component");
        console.log(endComponent.errorString());
        return null;
    }
    return endObject;
}
