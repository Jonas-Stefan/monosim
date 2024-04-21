extends componentBase

var lowColor: Color = Color(0.5, 0.5, 0.5)
var highColor: Color = Color(0.8, 0.1, 0.1)
var sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	for child in get_children():
		if child.get_class() == "Sprite2D":
			sprite = child
			break
	
	sprite.modulate = lowColor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	super._process(delta)

	if inputs[0].connectedOutput == null:
		state = false
	else:
		state = inputs[0].connectedOutput.get_parent().state

	if state:
		sprite.modulate = highColor
	else:
		sprite.modulate = lowColor
