extends Button

# var nameField: LineEdit
# var colorBtn: ColorPickerButton

# func _ready():
# 	nameField = get_parent().get_node("nameField")
# 	colorBtn = get_parent().get_node("colorBtn")
# 	self.pressed.connect(_on_finish_chip_btn_pressed)

# func _on_finish_chip_btn_pressed():
# 	create_new_chip()


# func create_new_chip() -> void:
# 	"""
# 	Creates a new chip out of all the chips, and components in the current project.
# 	I store the gates just as Strings, which hold their type, because I would have to create a copy of everything once I create an instance of a chip (because otherwise all chips would have the same state) and it's easier this way.
# 	The edges are stored as arrays with the indices of the connected nodes.
# 	I think this is probably the most efficient and easy way to do it, but I'm not sure. Atleast it's better than everything else I tried so far :)
# 	"""
# 	var chipResource: chipBase = chipBase.new()

# 	var root: Node2D = get_tree().get_root().get_node("root")

# 	var oldGateNodes: Array[graphNode] = []
# 	var gateTypes: Array[String] = []

# 	#add the gates to the new chip
# 	for node in root.componentGraph.nodes:
# 		if node.type != "lamp" and node.type != "":
# 			gateTypes.append(node.type)
# 			oldGateNodes.append(node)
	
# 	for chip in root.chips:
# 		for node in chip.chipGraph.nodes:
# 			oldGateNodes.append(node)
	
# 	var gateEdges: Array = []

# 	#add the wires to the new chip
# 	for edge in root.componentGraph.edges:
# 		var inputIndex = oldGateNodes.find(edge.input)
# 		var outputIndex = oldGateNodes.find(edge.output)

# 		#the edge would be connected with an input or output if the indices are -1, in that case I don't even need the edge.
# 		if inputIndex != -1 and outputIndex != -1:
# 			gateEdges.append([inputIndex, outputIndex])


# 	#add all the chips to the new chip
# 	for chip in root.chips:
# 		for edge in chip.chipResource.gateEdges:
# 			var edgeInput: int = edge[0] + gateTypes.size()
# 			var edgeOutput: int = edge[1] + gateTypes.size()
# 			gateEdges.append([edgeInput, edgeOutput])

# 		for node in chip.chipResource.gateTypes:
# 			gateTypes.append(node)


# 	#get the inputs of the chip
# 	var switches: Array[Node2D] = []
# 	var inputs: Array = []
# 	var lamps: Array[Node2D] = []
# 	var outputs: Array[int] = []

# 	for pin in root.pins:
# 		if pin.inputs.size() == 0:
# 			#switch
# 			switches.append(pin)
# 		elif pin.outputs.size() == 0:
# 			#lamp
# 			lamps.append(pin)
	
# 	switches.sort_custom(sort_by_y_pos)
# 	lamps.sort_custom(sort_by_y_pos)

# 	#set the inputs and outputs of the chip
# 	for switch in switches:
# 		var connectedNodes: Array = []
# 		var output: Node2D = switch.outputs[0]

# 		#iterate over all wires connected to the output
# 		for wire in output.wires:
# 			#append the index of the connected node to the connectedNodes array
# 			for edge in wire.edges:
# 				connectedNodes.append(oldGateNodes.find(edge.output))

# 		inputs.append(connectedNodes)
	

# 	for lamp in lamps:
# 		#get the old node connected to the lamp
# 		for edge in lamp.inputs[0].connectedWire.edges:
# 			var connectedOldNode: graphNode = edge.input
# 			#append the new counterpart of the old node to the outputs
# 			outputs.append(oldGateNodes.find(connectedOldNode))
	
# 	chipResource.name = nameField.text
# 	chipResource.color = colorBtn.color
# 	chipResource.inputs = inputs
# 	chipResource.outputs = outputs
# 	chipResource.gateTypes = gateTypes
# 	chipResource.gateEdges = gateEdges
	

# 	#save the chip resource
# 	if ResourceLoader.exists("res://Chips/Chips/" + chipResource.name + ".tres"):
# 		print("chip already exists")
# 	else:
# 		ResourceSaver.save(chipResource, "res://Chips/Chips/" + chipResource.name + ".tres")
# 	root.get_node("chipCreationScreen").hide()
	
# 	#add the chip to the top buttons
# 	#I will do it later :)
# 	var UInode = root.get_node("UI")
# 	var btnContainer = UInode.get_node("topButtons/VBoxContainer/MarginContainer/btnContainer")
# 	var newBtn = Button.new()
# 	newBtn.theme = load("res://UITheme.tres")
# 	newBtn.set_script(load("res://Scripts/UI/componentBtn.gd"))
# 	newBtn.name = chipResource.name
# 	newBtn.text = chipResource.name
# 	btnContainer.add_child(newBtn)



# func sort_by_y_pos(a: Node2D, b: Node2D) -> bool:
# 	return a.position.y < b.position.y
