extends gateComponent

var lowColor: Color = Color(0.5, 0.5, 0.5)
var highColor: Color = Color(0.8, 0.1, 0.1)
var sprite: Sprite2D

func _ready() -> void:
	super._ready()
	for child in get_children():
		if child.get_class() == "Sprite2D":
			sprite = child
			break
	
	sprite.modulate = lowColor

func _process(delta) -> void:
	super._process(delta)

	if node.state:
		sprite.modulate = highColor
	else:
		sprite.modulate = lowColor
	return