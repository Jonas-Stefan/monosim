extends Node
class_name globals

enum tools {MOVE, DELETE, EDIT}

static var selectedOutput: Node2D = null
static var tool: tools = tools.MOVE

static var gridSize: int  = 10

static func snap_to_grid(pos: Vector2) -> Vector2:
    var snappedVector: Vector2 = Vector2()
    snappedVector.x = round(pos.x / gridSize) * gridSize
    snappedVector.y = round(pos.y / gridSize) * gridSize
    return snappedVector
