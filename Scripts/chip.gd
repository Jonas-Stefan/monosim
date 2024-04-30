extends componentBase

var nextGateStates: Array[bool] = []
var gateStates: Array[bool] = []
@export var chipResource: chipBase:
	set(value):
		chipResource = value

		update_chip_resource()

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

	#remove the inputs and outputs added by the componentBase constructor
	for i in range(inputs.size()):
		inputs[0].queue_free()
		inputs.remove_at(0)
	for i in range(outputs.size()):
		outputs[0].queue_free()
		outputs.remove_at(0)
	
	update_chip_resource()
	for gate in chipResource.gates:
		gateStates.append(gate.state)

func _process(delta):
	super._process(delta)


func calculate() -> void:
	#clear the next state arrays
	nextGateStates = []


	#calculate the next state of every gate in the chip
	for gate in chipResource.gates:
		nextGateStates.append(calculate_gate(gate))

func set_next_state() -> void:
	#set the next state of the gates
	for i in range(nextGateStates.size()):
		gateStates[i] = nextGateStates[i]

	#set the actual outputs
	for i in range(outputs.size()):
		if typeof(chipResource.outputs[i]) == TYPE_INT:
			#pin as output (idk why you would do that, but you can)
			outputs[i].state = inputs[i].connectedOutput.state if inputs[i].connectedOutput != null else false
		elif chipResource.gates.find(chipResource.outputs[i]) != -1:
			outputs[i].state = gateStates[chipResource.gates.find(chipResource.outputs[i])]
		else:
			print("I didn't think of smth")

	return



func calculate_gate(gate: strippedGate) -> bool:
	var calcInputs: Array[bool] = []
	for input in gate.inputs:
		if input == null:
			#no input
			calcInputs.append(false)
		elif typeof(input) == TYPE_INT:
			#pin as input -> external input
			calcInputs.append(inputs[input].connectedOutput.state if inputs[input].connectedOutput != null else false)
		#elif input.get_class() == "Node2D":
			#if input.connectedOutput == null:
				#calcInputs.append(false)
			#else:
				#calcInputs.append(input.connectedOutput.state)
		else:
			#another gate as input
			#calcInputs.append(input.state)
			calcInputs.append(gateStates[chipResource.gates.find(input)])

	if gate.type == "AND":
		return calcInputs[0] and calcInputs[1]
	elif gate.type == "OR":
		return calcInputs[0] or calcInputs[1]
	elif gate.type == "NOT":
		return not calcInputs[0]
	else:
		return false



func update_chip_resource() -> void:
	#reset the inputs and outputs
	for i in range(inputs.size()):
		inputs[i].queue_free()
		inputs.remove_at(i)
	for i in range(outputs.size()):
		outputs[i].queue_free()
		outputs.remove_at(i)

	#change the appearance of the chip according to the chipResource
	$Label.text = chipResource.name
	$body.scale.y = max(0.2, max(chipResource.inputs * 0.067, chipResource.outputs.size() * 0.067))
	var chipWidth: int = $Label.size.x + 40
	chipWidth /= 2
	chipWidth = globals.snap_to_grid(Vector2(chipWidth, 0)).x
	chipWidth *= 2
	$body.scale.x = max(0.2, chipWidth / 600.0)
	$body.modulate = chipResource.color

	

	#the code for the inputs and outpus is pretty similar, maybe I could make a function for that?

	#add the input pins according to the switches

	#position of the highest input
	var topPosY: float
	if chipResource.inputs == 1:
		topPosY = 0
	elif chipResource.inputs % 2 == 0:
		#even number of inputs
		topPosY = (chipResource.inputs / 2.0 - 1.0) * -40 - 20
	else:
		topPosY = ((chipResource.inputs - 1) / 2.0) * -40


	for i in range(chipResource.inputs):
		var input: Node2D = load("res://Scenes/input.tscn").instantiate()
		input.position = Vector2(-chipWidth / 2.0 - 10, topPosY + i * 40)
		inputs.append(input)
		self.add_child(input)
	
	#add the output pins according to the lamps

	#position of the highest output
	if chipResource.outputs.size() == 1:
		topPosY = 0
	else:
		topPosY = (chipResource.outputs.size() / 2.0 - 1) * -40

	#decrease the position of the highest output by 20 if the number of outputs is even
	if chipResource.outputs.size() % 2 == 0 and chipResource.outputs.size() != 0:
		topPosY -= 20

	for i in range(chipResource.outputs.size()):
		var output: Node2D = load("res://Scenes/output.tscn").instantiate()
		output.position = Vector2(chipWidth / 2.0 + 10, topPosY + i * 40)
		outputs.append(output)
		self.add_child(output)
