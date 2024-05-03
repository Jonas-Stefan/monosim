class_name graphNode

var type: String
var inputs: Array[bool]
var state: bool

func _init(_type: String = "", _inputs: Array[bool] = [], _state: bool = false) -> void:
	self.type = _type
	self.inputs = _inputs
	self.state = _state
	return

func update_state() -> void:
	#update the state of the node based on the type and inputs of the node
	if type == "AND":
		fill_inputs(2)
		self.state = self.inputs[0] and self.inputs[1]
	elif type == "OR":
		fill_inputs(2)
		self.state = self.inputs[0] or self.inputs[1]
	elif type == "NOT":
		fill_inputs(1)
		self.state = not self.inputs[0]
	elif type == "lamp":
		fill_inputs(1)
		self.state = self.inputs[0]
	
	inputs = []

	return

func fill_inputs(inputCount: int) -> void:
	while inputs.size() < inputCount:
		inputs.append(false)
	return