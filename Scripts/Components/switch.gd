extends componentBase

var lowColor: Color = Color(0.5, 0.5, 0.5)
var highColor: Color = Color(0.8, 0.1, 0.1)
var sprite: Sprite2D

func _ready():
	super._ready()

	#find the sprite whose color I want to change
	for child in get_children():
		if child.get_class() == "Sprite2D":
			sprite = child
			break
	
	sprite.modulate = lowColor

func _process(delta):
	super._process(delta)

func _on_drag_area_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	super._on_drag_area_input_event(_viewport, event, _shape_idx)
	#check if the switch is toggled with a right click
	if event.is_action_pressed("rClick"):
		node.state = !node.state
		if node.state:
			sprite.modulate = highColor
		else:
			sprite.modulate = lowColor

	return
