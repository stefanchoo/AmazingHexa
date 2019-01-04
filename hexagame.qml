import QtQuick 2.4
import QtQuick.Controls 2.2
import Material 0.2
import Material.ListItems 0.1 as ListItem
import "images"
import "views"
import "controllers/GameControl.js" as GameControl

Window {
    id: root
    visible: true

    width: 1920
    height: 1032

    Rectangle {
        id: screen
        anchors.fill: parent
        color: "#666666"

        property int level: 1
        property int bestScore: 1960
        property int totalScore: 0
        property int secondRemain: 600
        property int pauseCount: 0

        property int actionScore: 0
        property string state: "idle" // 游戏的状态  idle running pause finished
        property var waitLevelList: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        property var doneLevelList: []
        property alias levelUpAction: levelUpImg
        property alias waitModel: waitLevelView.model
        property alias doneModel: doneLevelView.model
        property alias threeSecondsTimer: threeSeconds
        property alias twoSecondsTimer: twoSeconds
        property alias twentySecondsTimer: twentySeconds
        property alias fifteenSecondsTimer: fifteenSeconds

        signal started
        signal paused
        signal continued
        signal finished
        signal levelUp

        onBestScoreChanged: {
            infoBar.bestScoreView.style = "display1"
            actionTimer.start()
        }

        onTotalScoreChanged: {
            infoBar.scoreView.style = "display3"
            actionTimer.start()
            if (totalScore > bestScore)
                bestScore = totalScore
        }

        onSecondRemainChanged: {
            if (secondRemain <= 10) {
                infoBar.timeView.style = "display3"
                actionTimer.start()
            }
        }

        onLevelUp: {
            infoBar.levelView.style = "display2"
            actionTimer.start()
            GameControl.levelUp()
        }

        onStarted: {
            helpPage.visible = false
            infoBar.visible = true
            waitLevelView.visible = true
            doneLevelView.visible = true
            GameControl.start()
            state = "running"
        }

        onPaused: {
            state = "pause"
            pauseCount++
            helpPage.startButton.text = "继续游戏"
            helpPage.visible = true
            fifteenSecondsTimer.stop()
            twentySecondsTimer.stop()
        }

        onContinued: {
            helpPage.visible = false
            state = "running"
            fifteenSecondsTimer.start()
            twentySecondsTimer.start()
        }

        onFinished: {
            helpPage.visible = false
            state = "finished"
            levelUpImg.levelInfo = "游戏结束"
            levelUpImg.visible = true
            twoSecondsTimer.stop()
            threeSecondsTimer.stop()
            fifteenSecondsTimer.stop()
            twentySecondsTimer.stop()
        }

        // levelUp
        Timer {
            id: threeSeconds
            interval: 3000
            repeat: false
            running: false
            onTriggered: {
                levelUpImg.visible = false
                screen.levelUp()
            }
        }

        Timer {
            id: twoSeconds
            interval: 2000
            repeat: false
            running: false
            onTriggered: {
                GameControl.handleMatchTimeout()
            }
        }

        Timer {
            id: twentySeconds
            interval: 20000
            repeat: false
            running: false
            onTriggered: {
                GameControl.handleTouchTimeout()
            }
        }

        Timer {
            id: fifteenSeconds
            interval: 15000
            repeat: false
            running: false
            onTriggered: {
                GameControl.addOil()
            }
        }

        // 左侧未完成的
        ListView {
            id: waitLevelView
            width: 200
            height: 800
            clip: true
            visible: false
            anchors {
                top: mouseArea.top
                left: parent.left
                leftMargin: 40
            }
            highlight: Rectangle {
                border.color: "white"
                color: "#333333"
                border.width: 2
                radius: 8
            }
            highlightFollowsCurrentItem: true
            model: screen.waitLevelList
            delegate: Item {
                width: 200
                height: 200
                Image {
                    anchors.centerIn: parent
                    source: "images/level" + screen.waitLevelList[index] + ".png"
                }
            }
        }

        // 右侧已完成的
        ListView {
            id: doneLevelView
            width: 200
            height: 800
            clip: true
            visible: false
            anchors {
                top: mouseArea.top
                right: parent.right
                rightMargin: 40
            }
            model: screen.doneLevelList
            delegate: Item {
                width: 200
                height: 200
                Image {
                    anchors.centerIn: parent
                    source: "images/level" + screen.doneLevelList[screen.doneLevelList.length
                        - index - 1] + ".png"
                }
            }
        }

        InfoBar {
            id: infoBar
            width: parent.width
            visible: false

            Timer {
                id: actionTimer
                running: false
                interval: 500
                onTriggered: {
                    infoBar.timeView.style = "display2"
                    infoBar.scoreView.style = "display2"
                    infoBar.bestScoreView.style = "headline"
                    infoBar.levelView.style = "display1"
                }
            }
        }

        Item {
            id: levelUpImg
            width: 1200
            height: 800
            x: (parent.width - width) / 2
            y: (parent.height - height + 50) / 2
            z: 200
            visible: false
            property alias levelInfo: infomation.text

            focus: screen.state === "finished"

            Keys.onReturnPressed: quitBtn.clicked()

            Rectangle {
                anchors.fill: parent
                radius: 10
                color: "black"
                opacity: 0.5
            }

            IconButton {
                id: quitBtn
                anchors {
                    top: parent.top
                    topMargin: 50
                    right: parent.right
                    rightMargin: 50
                }
                enabled: screen.state === "finished"
                visible: enabled
                size: 50
                color: "white"
                iconName: "info/back"
                onClicked: {
                    // TODO 发送销毁游戏的信号
                    console.info("Quit Game")
                    Qt.quit()
                }
            }

            Row {
                width: 600
                height: 300
                anchors {
                    top: parent.top
                    topMargin: 150
                    horizontalCenter: parent.horizontalCenter
                }
                spacing: 10
                Repeater {
                    model: 8
                    Emitter {
                        anchors.top: parent.top
                        anchors.topMargin: Math.random(1) * 200
                    }
                }
            }

            Icon {
                name: "shape/crown"
                color: "#FFC100"
                size: 180
                anchors.centerIn: parent
            }
            Label {
                id: infomation
                text: "升级了"
                anchors {
                    top: parent.top
                    topMargin: 500
                    horizontalCenter: parent.horizontalCenter
                }
                color: "#FFC100"
                style: "display1"
            }

            Label {
                id: totalScoreLabel
                text: (screen.state === "finished") ? screen.actionScore : screen.totalScore
                anchors {
                    top: parent.top
                    topMargin: 300
                    right: parent.right
                    rightMargin: 120
                }
                color: "white"
                style: "display4"
            }

            Label {
                text: "最高分：" + screen.bestScore
                anchors {
                    top: parent.top
                    topMargin: 480
                    horizontalCenter: totalScoreLabel.horizontalCenter
                }
                color: "white"
                style: "display1"
            }
        }

        View {
            id: mouseArea
            width: 1200
            height: 800
            x: (parent.width - width) / 2
            y: (parent.height - height + 50) / 2

            MouseArea {
                anchors.fill: parent
                onPositionChanged: {
                    if (screen.state !== "running")
                        return
                    GameControl.handlePress(mouse.x, mouse.y)
                    GameControl.handleTargetMatch(mouse.x, mouse.y)
                }
            }
        }
        // 需要一张图片作为帮助文档
        HelpPage {
            id: helpPage
            x: (parent.width - width) / 2
            y: (parent.height - height + 50) / 2
        }
    }

    Timer {
        id: timeLeft
        repeat: true
        running: screen.state === "running"
        interval: 1000
        onTriggered: {
            screen.secondRemain--
            if (screen.secondRemain === 0) {
                running = false
                screen.finished()
            }
        }
    }

    Timer {
        id: scoreTimer
        repeat: true
        running: screen.state === "finished"
        interval: 3
        onTriggered: {
            screen.actionScore += 5
            if (screen.actionScore >= screen.totalScore) {
                screen.actionScore = screen.totalScore
                running = false
            }
        }
    }
}
