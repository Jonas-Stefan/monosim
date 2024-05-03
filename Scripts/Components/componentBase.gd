extends Node2D
class_name componentBase

#var state: bool = false
var selected: bool = false:
	set(value):
		if value == true:
			for child in get_children():
				if child.get_class() == "Sprite2D":
					child.self_modulate = Color(1, 1, 1, 1)
		else:
			for child in get_children():
				if child.get_class() == "Sprite2D":
					child.self_modulate = Color(0.8, 0.8, 0.8, 1)
		selected = value

var dragOffset: Vector2
var outputs: Array[Node2D]
var inputs: Array[Node2D]
var node: graphNode

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
	
	#create the graph node used for calculating states
	node = graphNode.new()

	#add the graph node to the graph
	get_tree().get_root().get_node("root").componentGraph.nodes.append(node)
	return

func _process(_delta) -> void:
	if selected and globals.tool == globals.tools.MOVE:
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
	if globals.tool == globals.tools.MOVE:
		handle_move_tool(event)
	elif globals.tool == globals.tools.DELETE:
		if event.is_action_pressed("lClick"):
			delete()
	elif globals.tool == globals.tools.EDIT:
		handle_change_tool(event)
	return

#handle the delete tool and generally deleting the component
func delete() -> void:
	var root: Node2D = get_tree().get_root().get_node("root")

	#delete the gate if it is one
	for i in range(root.gates.size()):
		if root.gates[i] == self:
			root.gates.remove_at(i)
			break
	
	for i in range(root.pins.size()):
		if root.pins[i] == self:
			root.pins.remove_at(i)
			break
	
	for i in range(root.chips.size()):
		if root.chips[i] == self:
			root.chips.remove_at(i)
			break

	for output in outputs:
		for wire in output.wires:
			wire.delete()
	
	for input in inputs:
		if input.connectedOutput != null:
			input.connectedWire.delete()
	
	queue_free()

#handles the move tool
func handle_move_tool(event: InputEvent) -> void:
	if event.is_action_pressed("lClick"):
		selected = true
		dragOffset = position - get_global_mouse_position()
	elif event.is_action_released("lClick"):
		selected = false

		#snap the component to the grid
		var dSnap: Vector2 = global_position - globals.snap_to_grid(global_position)
		position = globals.snap_to_grid(position)

		#snap the output lines to the grid
		for output in outputs:
			if output != null:
				for wire in output.wires:
					for i in range(wire.get_point_count() - 1):
						wire.set_wire_point_position(i + 1, wire.get_wire_point_position(i + 1) + dSnap)
		
		#snap the input lines to the grid
		for input in inputs:
			if input.connectedOutput != null:
				var wire: Line2D = input.connectedWire
				wire.set_wire_point_position(wire.get_wire_point_count() - 1, input.global_position - input.connectedOutput.global_position)

func handle_change_tool(event: InputEvent) -> void:
	var root: Node2D = get_tree().get_root().get_node("root")
	if event.is_action_pressed("lClick"):
		for gate in root.gates:
			gate.selected = false
		selected = true
