extends componentBase

var delay: int = 1:
	set(value):
		delay = value
		delayArray = []
		for i in range(0, delay):
			delayArray.append(false)
		$delay.text = str(delay) + " ticks"
var delayArray: Array[bool] = [false]
@onready var delayLabel: Label = $delay

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	delay = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)

func calculate() -> bool:
	if delay <= 1:
		if inputs[0].connectedOutput == null:
			return false
		else:
			return inputs[0].connectedOutput.state
	var returnState: bool = delayArray[0]

	delayArray.remove_at(0)

	if inputs[0].connectedOutput == null:
		delayArray.append(false)
	else:
		delayArray.append(inputs[0].connectedOutput.state)
	
	return returnState
