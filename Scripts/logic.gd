extends Node2D

var gates: Array[Node2D]
@export var tps: int = 1000
var simulationIsRunning: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_node("gates").get_children():
		gates.append(child)
	
	Input.set_use_accumulated_input(false)
	
	#start the game loop
	game_loop()


func _process(_delta) -> void:
	if globals.selectedOutput != null:
		if globals.selectedOutput.wires.size() == 0:
			return
		var wires: Array[Line2D] = globals.selectedOutput.wires
		var wire: Line2D = wires[wires.size() - 1]

		#detect if the user wants to add a new point to the line
		if Input.is_action_just_pressed("lClick"):
			wire.add_wire_point(get_global_mouse_position() - globals.selectedOutput.get_global_position())

			#check if it is the first point and add a second one if it is
			if wire.get_wire_point_count() == 1:
				wire.set_wire_point_position(0, Vector2(0, 0))
				wire.add_wire_point(Vector2(0, 0))

		#visualize the wire by updating the last point to the mouse position
		if wire.get_wire_point_count() > 0:
			#check if the user is holding ctrl and only draw straight lines in that case
			if Input.is_action_pressed("ctrl"):

				#detect if the y delta or the x delta is bigger
				var delta: Vector2 = get_global_mouse_position() - (globals.selectedOutput.get_global_position() + wire.get_wire_point_position(wire.get_wire_point_count() - 2))

				if abs(delta.x) > abs(delta.y):
					#draw the wire horizontally
					wire.set_wire_point_position(wire.get_wire_point_count() - 1, globals.snapToGrid(wire.get_wire_point_position(wire.get_wire_point_count() - 2) + Vector2(delta.x, 0)))
				else:
					#draw the wire vertically
					wire.set_wire_point_position(wire.get_wire_point_count() - 1, globals.snapToGrid(wire.get_wire_point_position(wire.get_wire_point_count() - 2) + Vector2(0, delta.y)))
			else:
				#draw the wire to the mouse position
				wire.set_wire_point_position(wire.get_wire_point_count() - 1, globals.snapToGrid(get_global_mouse_position() - globals.selectedOutput.get_global_position()))

func game_loop() -> void:
	while simulationIsRunning:
		#calculate the next state of all gates
		var nextStates: Array[bool] = []
		for gate in gates:
			nextStates.append(gate.calculate())
		
		for i in nextStates.size():
			gates[i].state = nextStates[i]
			
		#wait for the next tick
		await get_tree().create_timer(1.0 / tps).timeout
	
