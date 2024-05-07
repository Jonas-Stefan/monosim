extends Button

#this is used to change the tool when the buttons are clicked

func _ready():
	self.button_down.connect(_on_button_down)

func _on_button_down():
	#deselect all gates and check which button was clicked
	var root: Node2D = get_tree().get_root().get_node("root")
	for gate in root.gates:
		gate.selected = false
		
	if self.name == "move":
		globals.tool = globals.tools.MOVE
	elif self.name == "delete":
		globals.tool = globals.tools.DELETE
	