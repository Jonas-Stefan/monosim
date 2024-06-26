extends Node2D

#The arrays containing all of the components, used for stuff like chip creation
var gates: Array[Node2D] = []
var pins: Array[Node2D] = []
var chips: Array[Node2D] = []

@export var tps: float = 1000.0
var simulationIsRunning: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set the input to not accumulate input (some stuff would break otherwise)
	Input.set_use_accumulated_input(false)

	#start the simulation engine
	SimEngine.Start()

func _input(event: InputEvent) -> void:
	#deal with inputs regarding the wire, that is currently being added, if there is one
	if globals.selectedOutput != null:
		var selectedWires: Array[Line2D] = globals.selectedOutput.wires
		var wire: Line2D = selectedWires[selectedWires.size() - 1]

		if event.is_action_pressed("lClick"):
			add_wire_point(wire)
		
		if event.is_action_pressed("rClick"):
			wire.remove_wire_point(wire.get_wire_point_count() - 1)

func _process(_delta) -> void:
	#visualize the wire the user is currently adding
	if globals.selectedOutput != null:
		if globals.selectedOutput.wires.size() == 0:
			return
		var selectedWires: Array[Line2D] = globals.selectedOutput.wires
		var wire: Line2D = selectedWires[selectedWires.size() - 1]
		#visualize the wire by updating the last point to the mouse position
		visualize_wire(wire)

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
		#I really need to find a better solution, this is just ugly
		if dict["collider"].get_parent().get_script().resource_path == "res://Scripts/Components/output.gd" or dict["collider"].get_parent().get_script().resource_path == "res://Scripts/Components/input.gd":
			return

	#detect if the user wants to add a new point to the line
	wire.add_wire_point(get_global_mouse_position() - globals.selectedOutput.get_global_position())
