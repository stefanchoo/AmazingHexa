import QtQuick 2.0
import Material 0.2
import Material.ListItems 0.1 as ListItem

Item {
    height: 80 //childrenRect.height
    property int totalWidth: 0

    property alias timeView: time_lab
    property alias scoreView: score_lab
    property alias levelView: level_lab
    property alias bestScoreView: best_score_lab

    focus: screen.state === "running"

    Keys.onReturnPressed: pauseBtn.clicked()


    // Display the left time
    Label {
        id: time_lab
        anchors.left: parent.left
        anchors.leftMargin: 80
        anchors.verticalCenter: parent.verticalCenter
        text: display()
        color: screen.secondRemain <= 10 ? "#F44336" : "white"
        style: "display2"
    }

    // Display the number of score
    Label {
        id: score_lab
        anchors.centerIn: parent
        text: screen.totalScore
        color: "white"
        style: "display2"
    }

    Label {
        id: best_score_lab
        anchors {
            top: parent.top
            topMargin: 80
            horizontalCenter: parent.horizontalCenter
        }
        text: "最高分: " + screen.bestScore
        color: "white"
        style: "headline"
    }

    Label {
        id: level_lab
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 500
        text: "等级： " + screen.level
        color: "white"
        style: "display1"
    }

    IconButton {
        id: pauseBtn
        width: 60
        height: 60
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 120
        iconName: "info/help"
        color: enabled ? "white" : "#DDDDDD"
        size: 50
        enabled: screen.state === "running"
        onClicked: screen.paused()
    }

    function display() {
        var countDownText = ""
        if (screen.secondRemain / 60 < 10) {
            countDownText += "0"
        }
        countDownText += Math.floor(screen.secondRemain / 60)
        countDownText += ":"
        if (screen.secondRemain % 60 < 10) {
            countDownText += "0"
        }
        countDownText += Math.floor(screen.secondRemain % 60)
        return countDownText
    }
}
