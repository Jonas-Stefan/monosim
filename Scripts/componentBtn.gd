extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	self.button_down.connect(_on_button_down)

func _on_button_down():
	if self.name == "NOT":
		var gate: Node2D = load("res://BaseComponents/not.tscn").instantiate()
		add_gate(gate)
	elif self.name == "AND":
		var gate: Node2D = load("res://BaseComponents/and.tscn").instantiate()
		add_gate(gate)
	elif self.name == "OR":
		var gate: Node2D = load("res://BaseComponents/or.tscn").instantiate()
		add_gate(gate)
	elif self.name == "delay":
		var gate: Node2D = load("res://BaseComponents/delay.tscn").instantiate()
		add_gate(gate)
	elif self.name == "switch":
		var pin: Node2D = load("res://BaseComponents/switch.tscn").instantiate()
		add_pin(pin)
	elif self.name == "lamp":
		var pin: Node2D = load("res://BaseComponents/lamp.tscn").instantiate()
		add_pin(pin)
	else:
		print("error")
		return

func add_gate(gate: Node2D) -> void:
	reset_tool()

	var root: Node2D = get_tree().get_root().get_node("root")
	var gates: Node2D = root.get_node("gates")
	gate.selected = true
	gates.add_child(gate)
	root.gates.append(gate)

func add_pin(pin: Node2D) -> void:
	reset_tool()

	var root: Node2D = get_tree().get_root().get_node("root")
	var pins: Node2D = root.get_node("pins")
	pin.selected = true
	pins.add_child(pin)
	root.pins.append(pin)

func reset_tool() -> void:
	globals.tool = globals.tools.MOVE
	
	return