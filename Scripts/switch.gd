extends componentBase

var lowColor: Color = Color(0.5, 0.5, 0.5)
var highColor: Color = Color(0.8, 0.1, 0.1)
var sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	for child in get_children():
		if child.get_class() == "Sprite2D":
			sprite = child
			break
	
	sprite.modulate = lowColor

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)

func _on_drag_area_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	super._on_drag_area_input_event(_viewport, event, _shape_idx)
	if event.is_action_pressed("rClick"):
		for output in outputs:
			output.state = !output.state
			if output.state:
				sprite.modulate = highColor
			else:
				sprite.modulate = lowColor

	return
