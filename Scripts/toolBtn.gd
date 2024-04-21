extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	self.button_down.connect(_on_button_down)

func _on_button_down():
	if self.name == "move":
		globals.tool = globals.tools.MOVE
	elif self.name == "delete":
		globals.tool = globals.tools.DELETE
