extends componentBase

#export is neccecary!!!
@export var type: String

func _ready():
	super._ready()

func _process(delta) -> void:
	super._process(delta)
	
	return

func calculate() -> bool:
	var calcInputs: Array[bool] = []
	for input in inputs:
		if input.connectedOutput == null:
			calcInputs.append(false)
		else:
			calcInputs.append(input.connectedOutput.state)

	if type == "AND":
		return calcInputs[0] and calcInputs[1]
	elif type == "OR":
		return calcInputs[0] or calcInputs[1]
	elif type == "NOT":
		return not calcInputs[0]
	else:
		return false
