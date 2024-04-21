extends Node2D

var connectedOutput: Node2D = null
var connectedWire: Line2D

func _on_input_area_input_event(_viewport:Node, event:InputEvent, _shape_idx:int) -> void:
	if event.is_action_pressed("lClick") and connectedOutput == null and globals.selectedOutput != null:
		#connect the output to the input if the user actually wants to connect them
		var wires: Array[Line2D] = globals.selectedOutput.wires
		var wire: Line2D = wires[wires.size() - 1]

		#check if the user is holding the ctrl key, if he isn't, the output will be connected to the input
		if Input.is_action_pressed("ctrl"):
			#check if the endpoint of the wire is above the input and connect the output to the input in that case
			if wire.get_wire_point_global_position(wire.get_point_count() - 1) == global_position:
				connect_output(wire)
		else:
			connect_output(wire)
		
	elif event.is_action_pressed("rClick") and connectedOutput != null:
		connectedWire.delete()

func connect_output(wire: Line2D) -> void:
	#logicially connect the output to the input
	connectedOutput = globals.selectedOutput
	globals.selectedOutput.connectedInputs.append(self)

	#correctly place the last point of the wire
	wire.set_wire_point_position(wire.get_wire_point_count() - 1, global_position - globals.selectedOutput.global_position)

	#append the wire to the connectedWires array, so I can acces it later
	connectedWire = wire

	#finish the connection process
	globals.selectedOutput = null
