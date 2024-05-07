extends Node
class_name globals

#nothing much to see, just some global variables and functions used throughout the project

enum tools {MOVE, DELETE, EDIT}

static var selectedOutput: Node2D = null
static var nodeSelected: bool = false
static var tool: tools = tools.MOVE
static var graph: CSharpScript = load("res://Scripts/Graph/Graph.cs")
static var graphNode: CSharpScript = load("res://Scripts/Graph/GraphNode.cs")
static var graphEdge: CSharpScript = load("res://Scripts/Graph/GraphEdge.cs")

static var gridSize: int  = 10

static func snap_to_grid(pos: Vector2) -> Vector2:
	#snaps a vector2 to the global grid
	var snappedVector: Vector2 = Vector2()
	snappedVector.x = round(pos.x / gridSize) * gridSize
	snappedVector.y = round(pos.y / gridSize) * gridSize
	return snappedVector
