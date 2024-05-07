extends Camera2D

var panning: bool = false

func _input(event):
	#check for zooming
	if event.is_action_pressed("zoomOut"):
		change_zoom(1.1)
	if event.is_action_pressed("zoomIn"):
		change_zoom(1 / 1.1)
	
	#check for panning
	if event.is_action_pressed("pan"):
		panning = true
	if event.is_action_released("pan"):
		panning = false
	
	#pan the camera
	if event is InputEventMouseMotion:
		if panning:
			position -= event.relative / zoom

func change_zoom(multiplier: float):
	#adjust the position of the camera depending on the mouse position
	var mousePos = get_global_mouse_position()

	#zoom in or out
	zoom.x *= multiplier
	zoom.y *= multiplier

	position += mousePos - get_global_mouse_position()