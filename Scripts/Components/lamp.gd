extends gateComponent

#maybe I could customize the colors later? This would look pretty good I think
var lowColor: Color = Color(0.5, 0.5, 0.5)
var highColor: Color = Color(0.8, 0.1, 0.1)
var sprite: Sprite2D

func _ready() -> void:
	super._ready()

	#find the sprite whose color I want to change
	for child in get_children():
		if child.get_class() == "Sprite2D":
			sprite = child
			break
	
	sprite.modulate = lowColor

func _process(delta) -> void:
	super._process(delta)

	#change the color of the sprite based on the state of the node (this could be done more efficiently I think...)
	if node.state:
		sprite.modulate = highColor
	else:
		sprite.modulate = lowColor
	return
