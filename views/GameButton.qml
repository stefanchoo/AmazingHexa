import QtQuick 2.6
import QtQuick.Layouts 1.2
import Material 0.2

Rectangle {
    id: root
    width: 200
    property alias text: label.text
    property alias style: label.style
    height: 70
    radius: width == height ? width * 0.5 : width * 0.2

    signal click;

    color: enabled ? "#03A9F4" : "white"

    Label {
        id: label
        anchors.centerIn: parent
        color: enabled ? "white" : "#DDDDDD"
        style: "headline"
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.enabled
        onClicked: click();
    }
}
