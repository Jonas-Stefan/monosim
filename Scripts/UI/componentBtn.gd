extends Button

var root: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.button_down.connect(_on_button_down)
	
	root = get_tree().get_root().get_node("root")

	

func _on_button_down():
	if self.name == "NOT":
		var newGate: Node2D = load("res://BaseComponents/not.tscn").instantiate()
		add_gate(newGate)
	elif self.name == "AND":
		var newGate: Node2D = load("res://BaseComponents/and.tscn").instantiate()
		add_gate(newGate)
	elif self.name == "OR":
		var newGate: Node2D = load("res://BaseComponents/or.tscn").instantiate()
		add_gate(newGate)
	elif self.name == "delay":
		var newGate: Node2D = load("res://BaseComponents/delay.tscn").instantiate()
		add_gate(newGate)
	elif self.name == "switch":
		var pin: Node2D = load("res://BaseComponents/switch.tscn").instantiate()
		add_pin(pin)
	elif self.name == "lamp":
		var pin: Node2D = load("res://BaseComponents/lamp.tscn").instantiate()
		add_pin(pin)
	else:
		add_chip(self.name)
		return

func add_gate(newGate: Node2D) -> void:
	reset_tool()

	var gates: Node2D = root.get_node("gates")
	newGate.selected = true
	gates.add_child(newGate)
	root.gates.append(newGate)

func add_pin(pin: Node2D) -> void:
	reset_tool()

	var pins: Node2D = root.get_node("pins")
	pin.selected = true
	pins.add_child(pin)
	root.pins.append(pin)
	return

func add_chip(chipName: String) -> void:
	reset_tool()
	
	var chips: Node2D = root.get_node("chips")
	
	var newChip: Node2D = load("res://Chips/Prefab/chip.tscn").instantiate()
	newChip.chipResource = load("res://Chips/Chips/" + chipName + ".tres") #this may be buggy, I don't know though
	newChip.selected = true
	chips.add_child(newChip)
	return

func reset_tool() -> void:
	globals.tool = globals.tools.MOVE
	return
