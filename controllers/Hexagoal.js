/* This script file handles the Hexagoal logic */
.import QtQuick 2.0 as Quick

function calcuOffset(size, point) {
    var deltaX = size * (point[0] + point[1] * 0.5) * 0.5 * Math.sqrt(3);
    var deltaY = size * point[1] * 0.75;
    return [Number(deltaX), Number(deltaY)];
}
