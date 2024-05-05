extends Node
class_name globals

enum tools {MOVE, DELETE, EDIT}

static var selectedOutput: Node2D = null
static var nodeSelected: bool = false
static var tool: tools = tools.MOVE
static var graph: CSharpScript = load("res://Scripts/Graph/Graph.cs")
static var graphNode: CSharpScript = load("res://Scripts/Graph/GraphNode.cs")
static var graphEdge: CSharpScript = load("res://Scripts/Graph/GraphEdge.cs")

static var gridSize: int  = 10

static func snap_to_grid(pos: Vector2) -> Vector2:
    var snappedVector: Vector2 = Vector2()
    snappedVector.x = round(pos.x / gridSize) * gridSize
    snappedVector.y = round(pos.y / gridSize) * gridSize
    return snappedVector
