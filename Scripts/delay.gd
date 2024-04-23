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

func _input(event):
	if globals.tool == globals.tools.EDIT:
		if selected:
			if event is InputEventKey and event.is_pressed():
				if event.get_keycode() >= 48 and event.get_keycode() <= 57:
					delay = min(int(str(delay) + str(event.get_keycode() - 48)), 1000)
				elif event.get_keycode() >= 4194438 and event.get_keycode() <= 4194447:
					delay = int(str(delay) + str(event.get_keycode() - 4194438))
				elif event.get_keycode() == 4194308:
					delay = int(str(delay).substr(0, str(delay).length() - 1))
				elif event.get_keycode() == 4194309:
					selected = false
