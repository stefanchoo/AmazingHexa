/* This script file handles the game logic */
.import QtQuick 2.0 as Quick
.import "../controllers/EndEffect.js" as EndEffect
.import "../controllers/Graph.js" as Graph
.import "../controllers/CombineGroup.js" as CombineGroup
.import "../controllers/Combine.js" as Combine
.import "../controllers/Circle.js" as Circle
//.import "../controllers/GameControl.js" as GameControl

// 定义全局唯一的对象
var screen
var gameScreenObject
// 终端对象
var endEffectObject
// 目标点指示
var circleTargetObject
// 场景对象
var graphObject
// 基本图形组对象
var combineGroupObject
var combineObjects = [] // 基本图形数组 (需要被拖动，着色)
var targetPoints = [] // 目标点集合
// 数据组对象
var shapeList = []
var colorList = []
// 被拖动的基本形状
var dynamicObject
var colorObjects = [] // 被操作的颜色组

var currentTragetIndex = 0      // 当前目标点位

function createGameScreen(view, gameScreen) {
    screen = view    // 拿到外部对象
    shapeList = []
    colorList = []
    for(var i = 0; i < gameScreen.shapeList.length; i++) {
        shapeList.push(gameScreen.shapeList[i])
        colorList.push(gameScreen.colorList[i])
    }
    gameScreenObject = new Object
    var gameScreenComponent = Qt.createComponent("../views/GameScreen.qml")
      if(gameScreenComponent.status === Quick.Component.Ready) {
         gameScreenObject = gameScreenComponent.createObject(view);
          if (gameScreenObject === null) {
              console.log("error creating combine");
              console.log(gameScreenComponent.errorString());
              return null;
          }
          gameScreenObject.x = (view.width - gameScreenObject.width) / 2;
          gameScreenObject.y = (view.height - gameScreenObject.height + 50) / 2;
          startNewScene();
      } else {
          console.log("error loading block component");
          console.log(gameScreenComponent.errorString());
          return null;
      }
      return gameScreenObject;
}

// 创建场景
function startNewScene() {

    endEffectObject = new Object
    circleTargetObject = new Object
    graphObject = new Object
    combineGroupObject = new Object
    dynamicObject = new Object

    // 创建终端控件
    var endObject = Object
    endObject.x = 300
    endObject.y = 300
    endObject.size = 60
    endObject.bColor = "#03A9F4"
    endEffectObject = EndEffect.createEndEffect(gameScreenObject, endObject)

    var graph = Object
    graph.width = gameScreenObject.graphComponent.width
    graph.height = gameScreenObject.graphComponent.height
    graph.x = gameScreenObject.graphComponent.x
    graph.y = gameScreenObject.graphComponent.y
    graph.size = gameScreenObject.graphBlockSize
    graph.color = gameScreenObject.graphColor
    graph.shapeList = shapeList
    graph.status = "waitAssemble"
    graphObject = Graph.createGraph(gameScreenObject, graph)

    var combineGroup = Object
    combineGroup.width = gameScreenObject.combineGroupComponent.width
    combineGroup.height = gameScreenObject.combineGroupComponent.height
    combineGroup.x = gameScreenObject.combineGroupComponent.x
    combineGroup.y = gameScreenObject.combineGroupComponent.y
    combineGroup.size = gameScreenObject.shapeBlockSize
    combineGroup.color = gameScreenObject.shapeColor
    combineGroup.groupList = shapeList
    combineGroupObject = CombineGroup.createCombineGroup(gameScreenObject, combineGroup)

    // 场景创建成功， 获取被操作的基本图形组
    for (var i = 0; i < shapeList.length; i++) {
        combineObjects.push(CombineGroup.combineObjects[i])
        targetPoints.push(Combine.getAbsoluteTargetPoint(
                              CombineGroup.combineObjects[i]))
        targetPoints.push(Combine.getAbsoluteTargetPoint(
                              Graph.combineObjects[i]))
    }
    // 初始化色板
    for (var k = 0; k < colorList.length; k++) {
        console.info("颜色组：", colorList[k]);
        var colorObject = new Object
        colorObject.color = gameScreenObject.colorGroup[colorList[k]]
        colorObject.targetPoint = gameScreenObject.colorTargetPoints[colorList[k]]
        colorObjects.push(colorObject)
        targetPoints.push(colorObject.targetPoint)
        targetPoints.push(Combine.getAbsoluteTargetPoint(
                              Graph.combineObjects[k]))
    }
    //    标记出第一个目标点
    circleTargetObject = Circle.createTargetCircle(gameScreenObject, targetPoints[0])

    // 场景创建成功，开始游戏
    screen.twentySecondsTimer.start()
    screen.fifteenSecondsTimer.start()
}

function updateGameScreen(view, gameScreen) {

//    gameScreenObject.visible = false
//    endEffectObject.visible = false
//    circleTargetObject.visible = false
//    graphObject.visible = false
//    combineGroupObject.visible = false
//    dynamicObject.visible = false

   return createGameScreen(view, gameScreen);
}

function handleTargetMatch(xPos, yPos) {
    console.info("当前状态", graphObject.status)
    if(graphObject.status === "finished") return
    // 拖动状态
    if (graphObject.status === "onAssemble" && dynamicObject) {
        dynamicObject.x = endEffectObject.x  - (dynamicObject.width - endEffectObject.width) / 2
        dynamicObject.y = endEffectObject.y  - (dynamicObject.height - endEffectObject.height) / 2
    }

    if (Math.abs(targetPoints[0][0] - xPos) < 10 && Math.abs(
                targetPoints[0][1] - yPos) < 10) {
        console.info("到达目标点位：", currentTragetIndex)
        screen.twentySecondsTimer.stop()
        screen.fifteenSecondsTimer.stop()
        circleTargetObject.frequency = 500
        switch (graphObject.status) {
        case "waitAssemble":
            endEffectObject.state = "graspState"
            screen.twoSecondsTimer.start()
            break
        case "onAssemble":
            endEffectObject.state = "putState"
            screen.twoSecondsTimer.start()
            break
        case "waitColor":
            console.info("颜色选取成功，选取颜色：", colorObjects[0].color)
            endEffectObject.bColor = colorObjects[0].color
            endEffectObject.state = "graspState"
            screen.twoSecondsTimer.start()
            break
        case "onColor":
            console.info("着色成功：" + endEffectObject.bColor)
            endEffectObject.state = "putState"
            screen.twoSecondsTimer.start()
        }
    } else {
        // 脱离目标点，停止
        if(endEffectObject.state !== "moveState") {
            screen.twoSecondsTimer.stop()
            screen.twentySecondsTimer.start()
            circleTargetObject.frequency = 500
            screen.fifteenSecondsTimer.start()
            if(endEffectObject.state === "graspState") endEffectObject.value = 0
            else if(endEffectObject.state === "putState") endEffectObject.value = 100
            endEffectObject.state = "moveState"
        }
    }
}

function handleGrasp() {

    endEffectObject.value = 100
    endEffectObject.state = "moveState"

    // 挪到定时后进行
    graphObject.status = "onAssemble"
    dynamicObject = combineObjects[0]
    dynamicObject.bSize = gameScreenObject.graphBlockSize
    dynamicObject.fSize = dynamicObject.bSize + 2
    dynamicObject = Combine.updateCombine(gameScreenObject, dynamicObject)
    // 补位操作
    if(combineObjects.length > 3) combineObjects[3].visible = true;

    // 加分
    screen.totalScore += 10
    nextTargetPoint()
}


function handlePut() {

    endEffectObject.value = 0
    endEffectObject.state = "moveState"

    // 挪到定时后进行
    graphObject.status = "waitAssemble"
    dynamicObject.x = targetPoints[0][0] - (dynamicObject.width / 2)
    dynamicObject.y = targetPoints[0][1] - (dynamicObject.height / 2)
    // 移出首个操作点
    combineObjects.shift()
    if (combineObjects.length === 0) {
        graphObject.status = "assembled"
        // TODO 形状拼图成功，动画效果
        // 基本图形隐藏，调色板显示
        gameScreenObject.colorViewComponent.z = 100
        graphObject.status = "waitColor"
        // 重新拿到基本图形组
        for (var i = 0; i < shapeList.length; i++) {
            combineObjects.push(CombineGroup.combineObjects[i])
        }
    }

    // 加分
    screen.totalScore += 10
    nextTargetPoint()
}


function handleColor() {

    endEffectObject.value = 100
//    endEffectObject.bColor = colorObjects[0].color
    endEffectObject.state = "moveState"

    // 拖动颜色走？
    graphObject.status = "onColor"
    dynamicObject = combineObjects[0]
    colorObjects.shift() // 换下一个颜色

    // 加分
    screen.totalScore += 10
    nextTargetPoint()
}

function handlePaint() {

    endEffectObject.value = 0
    endEffectObject.state = "moveState"

    graphObject.status = "waitColor"
    dynamicObject.x = targetPoints[0][0] - (dynamicObject.width / 2)
    dynamicObject.y = targetPoints[0][1] - (dynamicObject.height / 2)
    dynamicObject.combineColor = endEffectObject.bColor
    dynamicObject = Combine.updateCombine(gameScreenObject, dynamicObject)
    // 移出首个操作点
    combineObjects.shift()

    // 加分
    screen.totalScore += 10

    if (combineObjects.length === 0) {
        graphObject.status = "colored"
        // TODO 涂色成功，动画效果
        console.info("涂色成功")
        graphObject.status = "finished"
        screen.doneLevelList.push(screen.waitLevelList.shift())
        screen.waitModel = screen.waitLevelList
        screen.doneModel = screen.doneLevelList
        circleTargetObject.visible = false
        screen.levelUpAction.visible = true
        // TODO: 发送信号
        if(screen.level === (screen.waitLevelList.length + screen.doneLevelList.length)) {
            console.info("Game Over")
            screen.levelUpAction.levelInfo = "恭喜通关";
            screen.state = "finished"
            return
        }
        screen.threeSecondsTimer.start()
    }

    nextTargetPoint()
}


function nextTargetPoint() {
    // 移出首个点
    targetPoints.shift()
    // TODO 动画
    if (targetPoints.length !== 0) {
        currentTragetIndex++
        circleTargetObject.x = targetPoints[0][0] - (circleTargetObject.width / 2)
        circleTargetObject.y = targetPoints[0][1] - (circleTargetObject.height / 2)
    }
}

function addOil() {
    circleTargetObject.frequency = 150
}

function handlePress(xPos, yPos) {
    if (!endEffectObject) {
        console.info("target object is null")
        return
    }
    if (xPos < 0)
        xPos = 0
    if (xPos > gameScreenObject.width)
        xPos = gameScreenObject.width
    if (yPos < 0)
        yPos = 0
    if (yPos > gameScreenObject.height)
        yPos = gameScreenObject.height
    console.log("鼠标点：", xPos, yPos)
    endEffectObject.x = xPos - endEffectObject.width / 2
    endEffectObject.y = yPos - endEffectObject.height / 2
    console.log("终端点：", endEffectObject.x, endEffectObject.y);
}


function handleGraspTimeout() {
    // 移出首个点
    handleGrasp()
    screen.totalScore -= 10
}

function handlePutTimeout() {
    handlePut()
    screen.totalScore -= 10
}

function handleColorTimeout() {
    endEffectObject.bColor = colorObjects[0].color
    handleColor()
    screen.totalScore -= 10
}

function handlePaintTimeout() {
    handlePaint()
    screen.totalScore -= 10
}

function getDevPointlist() {
    var pointlist = [];
    for( var i = 0; i < targetPoints.length; i++) {
        var x = xGame2Device(targetPoints[i][0], gameScreenObject.width);
        var y = yGame2Device(targetPoints[i][1], gameScreenObject.height);
        pointlist.push(x, y);
    }
    //console.debug("pointlist:", pointlist);
    return pointlist;
}

function xGame2Device(x, width) {
    var w = width * 1.0;
    var temp_x = ( (x) - (w * 0.5) ) / w *(-1);
    return temp_x;
}

function yGame2Device(y, height) {
    var h = height * 1.0;
    var temp_y = (y) / h - 0.1;
    return temp_y;
}



