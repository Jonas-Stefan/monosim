extends Camera2D

var panning: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func change_zoom(multiplier: float):
	#adjust the position of the camera depending on the mouse position
	var mousePos = get_global_mouse_position()

	#zoom in or out
	zoom.x *= multiplier
	zoom.y *= multiplier

	position += mousePos - get_global_mouse_position()

func _input(event):
	if event.is_action_pressed("zoomOut"):
		change_zoom(1.1)
	if event.is_action_pressed("zoomIn"):
		change_zoom(1 / 1.1)
	
	if event.is_action_pressed("pan"):
		panning = true
	if event.is_action_released("pan"):
		panning = false
	
	if event is InputEventMouseMotion:
		if panning:
			position -= event.relative / zoom
