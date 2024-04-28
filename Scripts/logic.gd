extends Node2D

var gates: Array[Node2D]
var pins: Array[Node2D]
var chips: Array[Node2D]
@export var tps: int = 1000
var simulationIsRunning: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load all gates
	for child in get_node("gates").get_children():
		gates.append(child)
	
	#load all I/O pins
	for child in get_node("pins").get_children():
		pins.append(child)
	
	#load all chips
	for child in get_node("chips").get_children():
		chips.append(child)
	
	#set the input to not accumulate input (some stuff would break otherwise)
	Input.set_use_accumulated_input(false)
	
	#start the game loop
	game_loop()


func _process(_delta) -> void:
	if globals.selectedOutput != null:
		if globals.selectedOutput.wires.size() == 0:
			return
		var wires: Array[Line2D] = globals.selectedOutput.wires
		var wire: Line2D = wires[wires.size() - 1]
		#visualize the wire by updating the last point to the mouse position
		visualize_wire(wire)

func game_loop() -> void:
	while simulationIsRunning:
		#calculate the next state of all gates
		var nextStates: Array[bool] = []
		for gate in gates:
			nextStates.append(gate.calculate())
		
		#calculate next state of all chips
		for chip in chips:
			chip.calculate()
		
		#set next state of all gates
		for i in nextStates.size():
			for output in gates[i].outputs:
				output.state = nextStates[i]

		#set next state of all chips
		for chip in chips:
			chip.set_next_state()
			
		#wait for the next tick
		await get_tree().create_timer(1.0 / tps).timeout

func visualize_wire(wire: Line2D) -> void:
	#I couldn't think of a better name for this function, but it shows the next wire piece the user would add when pressing left click
	if wire.get_wire_point_count() > 0:
		#check if the user is holding ctrl and only draw straight lines in that case
		if Input.is_action_pressed("ctrl"):

			#detect if the y delta or the x delta is bigger
			var delta: Vector2 = get_global_mouse_position() - (globals.selectedOutput.get_global_position() + wire.get_wire_point_position(wire.get_wire_point_count() - 2))

			if abs(delta.x) > abs(delta.y):
				#draw the wire horizontally
				wire.set_wire_point_position(wire.get_wire_point_count() - 1, globals.snap_to_grid(wire.get_wire_point_position(wire.get_wire_point_count() - 2) + Vector2(delta.x, 0)))
			else:
				#draw the wire vertically
				wire.set_wire_point_position(wire.get_wire_point_count() - 1, globals.snap_to_grid(wire.get_wire_point_position(wire.get_wire_point_count() - 2) + Vector2(0, delta.y)))
		else:
			#draw the wire to the mouse position
			wire.set_wire_point_position(wire.get_wire_point_count() - 1, globals.snap_to_grid(get_global_mouse_position() - globals.selectedOutput.get_global_position()))

func add_wire_point(wire: Line2D) -> void:
	#detect if the user actually clicked on the output
	var space: PhysicsDirectSpaceState2D = PhysicsServer2D.space_get_direct_state(get_world_2d().space)
	var params: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	params.position = get_global_mouse_position()
	params.collide_with_areas = true
	params.collide_with_bodies = false
	for dict in space.intersect_point(params):
		if dict["collider"].get_parent().name.substr(0, 6) == "output" or dict["collider"].get_parent().name.substr(0, 5) == "input":
			return

	#detect if the user wants to add a new point to the line
	wire.add_wire_point(get_global_mouse_position() - globals.selectedOutput.get_global_position())

func _input(event: InputEvent) -> void:
	if globals.selectedOutput != null:
		var wires: Array[Line2D] = globals.selectedOutput.wires
		var wire: Line2D = wires[wires.size() - 1]

		if event.is_action_pressed("lClick"):
			add_wire_point(wire)
		
		if event.is_action_pressed("rClick"):
			wire.remove_wire_point(wire.get_wire_point_count() - 1)
