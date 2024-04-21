extends Node2D
class_name componentBase

var state: bool = false
var selected: bool = false
var dragOffset: Vector2
var outputs: Array[Node2D]
var inputs: Array[Node2D]

func _ready() -> void:
	#identify the area to drag
	for i in range(get_child_count()):
		if get_child(i).get_class() == "Area2D":
			get_child(i).connect("input_event", _on_drag_area_input_event)
			break
	
	#iterate over all children and find the input and output nodes
	for child in get_children():
		if child.name.substr(0, 5) == "input" and child.get_class() == "Node2D":
			inputs.append(child)
		elif child.name.substr(0, 6) == "output" and child.get_class() == "Node2D":
			outputs.append(child)
	return

func _process(_delta) -> void:
	if selected:
		#move the node to the global mouse position
		var currentMousePos = get_global_mouse_position()
		var dPos = currentMousePos + dragOffset - global_position

		#move the output lines against the movement of the parent node
		for output in outputs:
			if output != null:
				#iterate over all output wires
				for wire in output.wires:
					#iterate over all points of the wire except for the first one
					for i in range(wire.get_point_count() - 1):
						#move the wire point against the movement of the parent node
						wire.set_wire_point_position(i + 1, wire.get_wire_point_position(i + 1) - dPos)
				
		position = currentMousePos + dragOffset

		#move the input lines against the movement of the parent node (maybe I should rework this lol)
		for input in inputs:
			if input.connectedOutput != null:
				#iterate over all connected wires
				var wire: Line2D = input.connectedWire
				#move the wire point with the parent node
				wire.set_wire_point_position(wire.get_wire_point_count() - 1, wire.get_wire_point_position(wire.get_wire_point_count() - 1) + dPos)
	
	return


func _on_drag_area_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event.is_action_pressed("lClick"):
		selected = true
		dragOffset = position - get_global_mouse_position()
	elif event.is_action_released("lClick"):
		selected = false

		#snap the component to the grid
		var dSnap: Vector2 = global_position - globals.snapToGrid(global_position)
		position = globals.snapToGrid(position)

		#snap the output lines to the grid
		for output in outputs:
			if output != null:
				for wire in output.wires:
					for i in range(wire.get_point_count() - 1):
						wire.set_wire_point_position(i + 1, wire.get_wire_point_position(i + 1) + dSnap)
		
		#snap the input lines to the grid
		for input in inputs:
			if input.connectedOutput != null:
				for i in range(input.connectedOutput.connectedInputs.size()):
					if input.connectedOutput.connectedInputs[i].get_parent() == self:
						var wires: Array[Line2D] = input.connectedOutput.wires
						wires[i].set_wire_point_position(wires[i].get_wire_point_count() - 1, input.global_position - input.connectedOutput.global_position)
	
	return
