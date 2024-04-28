extends Button

var nameField: LineEdit
var colorBtn: ColorPickerButton

func _ready():
	nameField = get_parent().get_node("nameField")
	colorBtn = get_parent().get_node("colorBtn")
	self.pressed.connect(_on_finish_chip_btn_pressed)

func _on_finish_chip_btn_pressed():
	create_new_chip()


func create_new_chip() -> void:
	"""
	Concept:
	Convert the current state of the editor to a chip resource and save it.
	This is done by converting (almost) every component into its 'stripped' version, which is just a data structure that contains everything that is needed to simulate the component.
	Then, if a chip is in the editor, the components of the chip are 'extracted' from the chip and every connection, that went to the I/O of the chip is rerouted to the inputs/outputs that are connected to the chip.
	This procedure should be the simplest/most effective way to save a chip because everything is simplified to just gates. This saves me from the headache that would be caused by trying to have chips in chips, which is annoying 
	and too performance intensive too sensibly implement.

	My old concept wasn't even working because I tried to bruteforce it way too late at night, so I only wrote brainrot code lol. I should remember to always prototype in the future :)
	"""
	#the root node
	var root: Node2D = get_tree().get_root().get_node("root")

	#the chip
	var chipResource: chipBase = chipBase.new()

	#set the appearance of the chip
	var color: Color = colorBtn.color
	chipResource.color = color
	var chipName: String = nameField.text
	chipResource.name = chipName



	#set inputs of the chip
	var switches: Array[Node2D] = []
	for pin in root.get_node("pins").get_children():
		if pin.inputs.size() == 0:
			switches.append(pin)
	switches.sort_custom(sort_by_y_pos)
	chipResource.inputs = switches.size()



	#convert the gates to resources and add them to the chip
	var strippedGates: Array[strippedGate] = []
	var gates: Array[Node2D] = []

	#converting the gates to stripped gates
	for gate in root.get_node("gates").get_children():
		var gateRes: strippedGate = strippedGate.new()
		gateRes.type = gate.type
		strippedGates.append(gateRes)
		gates.append(gate)
	
	#finishing the conversion (I have to do it after filling the gates array, because there is a very big chance, that a gate has a gate as input, that isn't already added)
	for i in range(strippedGates.size()):
		for input in gates[i].inputs:
			if input.connectedOutput == null:
				strippedGates[i].inputs.append(null)
			elif gates.find(input.connectedOutput.get_parent(), 0) != -1:
				strippedGates[i].inputs.append(strippedGates[gates.find(input.connectedOutput.get_parent(), 0)])
			elif switches.find(input.connectedOutput.get_parent(), 0) != -1:
				strippedGates[i].inputs.append(switches.find(input.connectedOutput.get_parent(), 0))
			else:
				print("error, the input of a gate is connected to something that isn't a gate or a switch or a pin")
	


	#add the gates from the chips

	#add all chips to an array
	var chips: Array[Node2D] = []
	for chip in root.get_node("chips").get_children():
		chips.append(chip)

	#iterate over all chips
	for chip in chips:
		#iterate over all the gate in each chip
		for gate in chip.chipResource.gates:
			strippedGates.append(gate)

		#iterate over all the gates of the chip
		for gate in chip.chipResource.gates:
			#iterate over all the inputs of the gate
			for input in gate.inputs:
				#check if the input of a gate is connected to a pin of the chip and rewire it in that case
				if typeof(input) == TYPE_INT:
					#check if the pin is connected to nothing
					if chip.inputs[input].connectedOutput == null:
						input = null
					
					#check if the pin is connected to a switch
					elif switches.find(chip.inputs[input].connectedOutput.get_parent(), 0) != -1:
						#find the index of the switch
						var index: int = switches.find(chip.inputs[input].connectedOutput.get_parent(), 0)
						input = index
					
					#check if the pin is connected to a gate
					elif gates.find(chip.inputs[input].connectedOutput.get_parent(), 0) != -1:
						#find the index of the gate
						input = strippedGates[gates.find(chip.inputs[input].connectedOutput.get_parent(), 0)]
					
					#check if the pin is connected to a chip
					elif chips.find(chip.inputs[input].connectedOutput.get_parent(), 0) != -1:
						var connectedChip: Node2D = chip.inputs[input].connectedOutput.get_parent()
						var outputIndex: int = connectedChip.outputs.find(chip.inputs[input].connectedOutput, 0)
						var internalOutput: Resource = connectedChip.chipResource.outputs[outputIndex]

						if typeof(internalOutput) == TYPE_INT:
							#the output is connected to an input of the chip
							input = connectedChip.inputs[internalOutput]
						else:
							input = internalOutput
					else:
						print("error, the pin is connected to something that isn't a gate or a switch or a pin")

	chipResource.gates = strippedGates

	chipResource.outputs = []
	#set the outputs of the chip
	var lamps: Array[Node2D] = []
	for pin in root.get_node("pins").get_children():
		if pin.outputs.size() == 0:
			lamps.append(pin)
	lamps.sort_custom(sort_by_y_pos)
	for lamp in lamps:
		if chips.find(lamp.inputs[0].connectedOutput.get_parent(), 0) != -1:
			#the input is a chip
			var connectedChip: Node2D = lamp.inputs[0].connectedOutput.get_parent()
			var outputIndex: int = connectedChip.outputs.find(lamp.inputs[0].connectedOutput, 0)
			var internalOutput: Resource = connectedChip.chipResource.outputs[outputIndex]

			if typeof(internalOutput) == TYPE_INT:
				#the output is connected to an input of the chip
				chipResource.outputs.append(connectedChip.inputs[internalOutput])
			else:
				chipResource.outputs.append(internalOutput)
			print("the input is a chip, implement this later")
		elif switches.find(lamp.inputs[0].connectedOutput.get_parent(), 0) != -1:
			#the input is a switch
			chipResource.outputs.append(switches.find(lamp.inputs[0].connectedOutput.get_parent(), 0))
		elif gates.find(lamp.inputs[0].connectedOutput.get_parent(), 0) != -1:
			#the input is a gate
			chipResource.outputs.append(strippedGates[gates.find(lamp.inputs[0].connectedOutput.get_parent(), 0)])
		else:
			print("error, the input of a lamp is connected to something that isn't a gate or a switch or a pin")
		#find the input of the lamp and add it to the outputs of the chip
		pass



	#save the chip resource
	if ResourceLoader.exists("res://Chips/Chips/" + chipResource.name + ".tres"):
		print("chip already exists")
	else:
		ResourceSaver.save(chipResource, "res://Chips/Chips/" + chipResource.name + ".tres")
		get_tree().get_root().get_node("root").get_node("chipCreationScreen").hide()
	
	#add the chip to the top buttons
	#I will do it later :)



func sort_by_y_pos(a: Node2D, b: Node2D) -> bool:
	return a.position.y < b.position.y