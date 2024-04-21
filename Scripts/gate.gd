extends componentBase

@export var type: String

func _ready():
	super._ready()

func _process(delta) -> void:
	super._process(delta)
	
	return

func calculate() -> bool:
	for input in inputs:
		if input.connectedOutput == null:
			return false
	if type == "AND":
		return inputs[0].connectedOutput.state and inputs[1].connectedOutput.state
	elif type == "OR":
		return inputs[0].connectedOutput.state or inputs[1].connectedOutput.state
	elif type == "NOT":
		return not inputs[0].connectedOutput.state
	else:
		return false
