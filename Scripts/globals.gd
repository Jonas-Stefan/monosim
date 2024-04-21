extends Node
class_name globals

static var selectedOutput: Node2D = null
static var gridSize: int  = 10

static func snapToGrid(pos: Vector2) -> Vector2:
    var snappedVector: Vector2 = Vector2()
    snappedVector.x = round(pos.x / gridSize) * gridSize
    snappedVector.y = round(pos.y / gridSize) * gridSize
    return snappedVector