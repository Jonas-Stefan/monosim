extends Node2D

var wiresNode: Node2D
var wires: Array[Line2D]
var connectedInputs: Array[Node2D] = []

func _ready():
	wiresNode = get_node("wires")

func _on_input_area_input_event(_viewport:Node, event:InputEvent, _shape_idx:int) -> void:
	if event.is_action_pressed("lClick"):
		if globals.selectedOutput != null:
			var foreignWires: Array[Line2D] = globals.selectedOutput.wires
			var wire: Line2D = foreignWires[foreignWires.size() - 1]
			wire.delete()

		globals.selectedOutput = self
		var newWire: Line2D = load("res://BaseComponents/wire.tscn").instantiate()
		wires.append(newWire)
		wiresNode.add_child(newWire)
		
		#two starter points
		newWire.add_wire_point(Vector2(0, 0))
		newWire.add_wire_point(Vector2(0, 0))
