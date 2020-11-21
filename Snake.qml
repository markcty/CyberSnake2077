import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

QtObject {
    id: snake
    property var points
    property color color
    property int speed: 0
    property string direction
    function move() {
        let points = snake.points, length = snake.points.length, direction = snake.direction, speed = snake.speed
        let newPoints = []
        // move point according to the direction
        function getNextPoint(point, direction, speed) {
            switch (direction) {
            case 'up':
                return {
                    "x": point.x,
                    "y": point.y - speed
                }
            case 'down':
                return {
                    "x": point.x,
                    "y": point.y + speed
                }
            case 'left':
                return {
                    "x": point.x - speed,
                    "y": point.y
                }
            case 'right':
                return {
                    "x": point.x + speed,
                    "y": point.y
                }
            }
        }
        // get the direction from point0 to point1
        function getDirection(point0, point1) {
            if (point0.x === point1.x) {
                if (point0.y > point1.y)
                    return "down"
                else
                    return "up"
            } else if (point0.y === point1.y) {
                if (point0.x > point1.x)
                    return "right"
                else
                    return "left"
            }
        }

        // when the snake is moving, only the first point and the last two points may be changed

        // add first point(s)
        if (getDirection(points[0], points[1]) !== direction) {
            newPoints.push(getNextPoint(points[0], direction, speed))
            newPoints.push(points[0])
        } else
            newPoints.push(getNextPoint(points[0], direction, speed))
        // add all the points except the last point
        for (var i = 1; i < length - 2; i++) {
            newPoints.push(points[i])
        }
        // add the last two points
        let lastLength = Math.abs(points[length - 1].x - points[length - 2].x
                                  + points[length - 1].y - points[length - 2].y)
        if (lastLength < speed) {
            newPoints.push(getNextPoint(points[length - 2],
                                        getDirection(points[length - 3],
                                                     points[length - 2]),
                                        speed - lastLength))
        } else {
            if (length > 2)
                newPoints.push(points[length - 2])
            newPoints.push(getNextPoint(points[length - 1],
                                        getDirection(points[length - 2],
                                                     points[length - 1]),
                                        speed))
        }
        snake.points = newPoints
    }
}
