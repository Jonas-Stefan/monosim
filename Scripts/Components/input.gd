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
	#create a edge for the component graph
	#check if the input belongs to a chip
	var inputNode
	var outputNodes: Array = []

	#My way of checking if the pin belongs to a chip is probably pretty bad, but I don't know how to do it better

	if globals.selectedOutput.get_parent().get_script().resource_path == "res://Scripts/Components/chip.gd":
		#the input of the edge is a chip
		var chip: Node2D = globals.selectedOutput.get_parent()
		var outputIndex = chip.outputs.find(globals.selectedOutput)
		inputNode = chip.chipGraph.GetNode(chip.chipResource.outputs[outputIndex])
	else:
		#the input of the edge is a component
		inputNode = globals.selectedOutput.get_parent().node
	

	if get_parent().get_script().resource_path == "res://Scripts/Components/chip.gd":
		#the output of the edge is a chip
		var chip: Node2D = get_parent()
		var inputIndex = chip.inputs.find(self)
		var inputIndices = chip.chipResource.inputs[inputIndex]
		for index in inputIndices:
			outputNodes.append(chip.chipGraph.GetNode(index))
	else:
		#the output of the edge is a component
		outputNodes.append(get_parent().node)

	for outputNode in outputNodes:
		var edge = globals.graphEdge.new()
		edge.input = inputNode
		edge.output = outputNode
		SimEngine.mainGraph.AddGraphEdge(edge)
		wire.edges.append(edge)

	#logicially connect the output to the input
	connectedOutput = globals.selectedOutput
	globals.selectedOutput.connectedInputs.append(self)

	#correctly place the last point of the wire
	wire.set_wire_point_position(wire.get_wire_point_count() - 1, global_position - globals.selectedOutput.global_position)

	#append the wire to the connectedWires array, so I can acces it later
	connectedWire = wire

	#finish the connection process
	#waiting for a short time isn't the cleanest solution, but everything else would probably be unnecessarily complicated
	await get_tree().create_timer(0.1, false).timeout
	globals.selectedOutput = null
