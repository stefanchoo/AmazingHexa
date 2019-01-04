// The Master Control of HexGame
.import QtQuick 2.0 as Quick
.import "GameScreen.js" as GameScreen

var gameCanvas
var endEffectObject

var levelDataList = [
        [ [ [-1, 0] ], [ [0, 0] ], [ [1, 0] ] ],                                                          // level 1
        [ [ [-1, 0]], [[0, -1], [0, 0] ], [ [1, 0] ] ],                                                   // level 2
        [ [ [0, -1], [-1, 0] ], [ [0, 0], [1, 0] ],[ [0, 1] ] ],                                          // level 3
        [ [ [-1, 0], [-1, 1] ], [[0, -1], [0, 0], [0, 1] ], [ [1, -1], [1, 0] ] ],                        // level 4
        [ [ [-1, 0], [-2, 1], [-1, 1] ], [ [0, -1], [0, 0], [0, 1] ], [ [1, -1], [2, -1], [1, 0] ] ],     // level 5
        [ [ [0, 0] ], [ [0, -2], [1, -2], [2, -2] ], [ [0, -1], [1, -1] ], [ [-1, 1], [0, 1] ], [ [-2, 2], [-1, 2], [0, 2] ] ],
        [ [ [1, 0] ], [ [-1, 0], [0, 0] ], [ [1, -2], [0, -1], [1, -1] ], [ [-2, 1], [-1, 1] ], [ [0, 1], [1, 1] ] ],
        [ [ [0, -2], [1, -2] ], [ [2, -2] ], [ [-1, -1], [-2, 0], [-1, 0] ], [[0, 0]], [ [2, -1], [1, 0], [2, 0] ], [ [0, -1], [1, -1] ] ],
        [ [ [0, 0] ], [ [0, -1], [-1, 0], [-1, 1] ], [ [1, -1], [1, 0], [0, 1] ], [ [0, -2] ], [ [2, -2] ], [ [-2, 0] ], [[2, 0] ], [ [-2, 2] ], [[0, 2] ] ],
        [ [ [-1, -1] ], [ [0, -2], [1, -2], [2, -2] ], [ [0, -1], [1, -1] ], [ [2, -1] ], [ [-1, 0], [0, 0], [1, 0] ], [ [-1, 1], [0, 1] ], [ [-2, 1] ], [ [-2, 2], [-1, 2], [0, 2] ], [ [1, 1] ] ]
        ]
var levelColorList = [
         [2, 4, 3] ,
         [1, 3, 5] ,
         [1, 2, 4] ,
         [1, 5, 4] ,
         [2, 1, 5] ,
         [2, 5, 1, 1, 5] ,
         [2, 4, 1, 3, 5] ,
         [2, 3, 5, 4, 5, 1] ,
         [2, 1, 1, 5, 5, 5, 5, 5, 5] ,
         [6, 6, 0, 6, 6, 0, 6, 6, 6]
        ]

function start() {
    var gameScreen = Object
    gameScreen.shapeList = levelDataList[0];
    gameScreen.colorList = levelColorList[0];
    gameCanvas = GameScreen.createGameScreen(screen, gameScreen)
    gameCanvas.devpointlist = GameScreen.getDevPointlist();
    console.debug("gameCanvas.getDevPointlist()", gameCanvas.devpointlist);
}

function pause() {}

function finished() {
    // 游戏结束
    console.info("游戏结束");
}

function levelUp() {
    console.info("level up ...")
    screen.level++
    gameCanvas.visible = false
//    gameCanvas = Object
    var gameScreen = Object
    gameScreen.shapeList = levelDataList[screen.level - 1];
    gameScreen.colorList = levelColorList[screen.level - 1];
    gameCanvas = GameScreen.updateGameScreen(screen, gameScreen)
}

function handlePress(xPos, yPos) {
    GameScreen.handlePress(xPos, yPos)
}

function handleTargetMatch(xPos, yPos) {
    GameScreen.handleTargetMatch(xPos, yPos)
}

function handleMatchTimeout() {
     switch(GameScreen.graphObject.status) {
        case "waitAssemble":
            GameScreen.handleGrasp()
            break
        case "onAssemble":
            GameScreen.handlePut()
            break
        case "waitColor":
            GameScreen.handleColor()
            break
        case "onColor":
            GameScreen.handlePaint()
            break
     }
     screen.twentySecondsTimer.start()
     GameScreen.circleTargetObject.frequency = 500
     screen.fifteenSecondsTimer.start()
}

// 20s 内触碰不到目标点（认为到达不了，需要改变目标点）
function handleTouchTimeout() {
    switch(GameScreen.graphObject.status) {
       case "waitAssemble":
           GameScreen.handleGraspTimeout()
           break
       case "onAssemble":
           GameScreen.handlePutTimeout()
           break
       case "waitColor":
           GameScreen.handleColorTimeout()
           break
       case "onColor":
           GameScreen.handlePaintTimeout()
           break
    }
    screen.twentySecondsTimer.start()
    GameScreen.circleTargetObject.frequency = 500
    screen.fifteenSecondsTimer.start()
}

// 15s 计时到，显示加油标志
function addOil() {
    GameScreen.addOil()
}
