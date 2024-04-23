extends Line2D

var wireAreas: Array[Area2D] = []
var areaWidth: int = 8

#takes a point relative to the origin of the wire and adds it to the wire
func add_wire_point(point: Vector2) -> void:
	#add the point to the line2d
	add_point(point)

	#add the according area2d
	if get_point_count() == 1:
		return
	var area = Area2D.new()
	area.position = point - get_point_position(get_point_count() - 2)
	area.rotation = point.angle_to(get_point_position(get_point_count() - 2))
	add_child(area)
	#add the collision shape to the area2d
	var collisionShape = CollisionShape2D.new()
	var collisionShapeShape = RectangleShape2D.new()
	collisionShapeShape.size = Vector2(0, areaWidth)
	collisionShape.shape = collisionShapeShape
	area.add_child(collisionShape)
	wireAreas.append(area)
	area.input_event.connect(_on_wire_area_input_event.bind(wireAreas.size() - 1))
	return

func set_wire_point_position(index: int, pos: Vector2) -> void:
	#set the point in the line2d
	set_point_position(index, pos)
	if index == 0:
		return

	#calculate everything for the area2d
	var angle: float = atan2(pos.y - get_point_position(index - 1).y, pos.x - get_point_position(index - 1).x)
	var length: float = pos.distance_to(get_point_position(index - 1))

	#adjust the area2d
	wireAreas[index - 1].position = pos - Vector2(cos(angle) * length, sin(angle) * length) / 2
	wireAreas[index - 1].rotation = angle
	wireAreas[index - 1].get_child(0).shape.size = Vector2(length, areaWidth)
	return

func remove_wire_point(index: int) -> void:
	if get_point_count() == 2:
		globals.selectedOutput = null
		delete()
		return
	
	#remove the point from the line2d
	remove_point(index)
	if index == 0:
		return

	#remove the area2d
	wireAreas[index - 1].queue_free()
	wireAreas.remove_at(index - 1)
	return

func get_wire_point_position(index: int) -> Vector2:
	return get_point_position(index)

func get_wire_point_global_position(index: int) -> Vector2:
	return get_point_position(index) + global_position

func get_wire_point_count() -> int:
	return get_point_count()

func delete() -> void:
	var index: int = -1
	var parent: Node2D = get_parent().get_parent()

	#find the index of the wire in the parent
	for i in range(parent.wires.size()):
		if parent.wires[i] == self:
			index = i
			break
	
	if index == -1:
		return

	#logically disconnect output and input
	parent.wires.remove_at(index)
	if index < parent.connectedInputs.size():
		parent.connectedInputs[index].connectedOutput = null
		parent.connectedInputs[index].connectedWire = null
		parent.connectedInputs.remove_at(index)

	#delete the wire
	for area in wireAreas:
		area.queue_free()
	queue_free()
	return

func _on_wire_area_input_event(_viewport:Node, event:InputEvent, _shape_idx:int, wireIndex: int) -> void:
	if globals.selectedOutput != null:
		return

	#delete the wire
	if event.is_action_pressed("rClick"):
		delete()
	
	#create a new wire
	if event.is_action_pressed("lClick"):
		#check if the mouse is hovering over an in-/output by using intersect_point
		var space: PhysicsDirectSpaceState2D = PhysicsServer2D.space_get_direct_state(get_world_2d().space)
		var params: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
		params.position = get_global_mouse_position()
		params.collide_with_areas = true
		params.collide_with_bodies = false
		for dict in space.intersect_point(params):
			if dict["collider"].get_parent().name.substr(0, 5) == "input" or dict["collider"].get_parent().name.substr(0, 6) == "output":
				print("return")
				return

		#actually create the new wire
		var newWire: Line2D = load("res://Scenes/wire.tscn").instantiate()
		print("new wire")

		#add the wire to the scene, assuming the path is 'output' - 'wires' - 'wire'
		get_parent().get_parent().wires.append(newWire)
		get_parent().add_child(newWire)
		for i in range(wireIndex + 1):
			print("adding wire point")
			newWire.add_wire_point(get_wire_point_position(i))
		
		#add a final point to the wire
		#distance between last point and mouse
		var distance: Vector2 = get_global_mouse_position() - get_wire_point_global_position(wireIndex)
		var length: int = int(globals.snap_to_grid(Vector2(distance.length(), 0)).x)
		print("length: " + str(length))

		#angle between last point and next point in the 'parent wire'
		var lastPoint: Vector2 = newWire.get_wire_point_position(newWire.get_point_count() - 1)
		var nextPoint: Vector2 = get_wire_point_position(wireIndex + 1)
		var angle: float = atan2(nextPoint.y - lastPoint.y, nextPoint.x - lastPoint.x)
		print("angle: " + str(rad_to_deg(angle)))

		#add the point
		print(newWire.get_point_count())
		newWire.add_wire_point(get_wire_point_position(wireIndex) + Vector2(cos(angle) * length, sin(angle) * length))
		print("added final point")
		print(newWire.get_point_count())

		#add a point that will move with the mouse
		newWire.add_wire_point(Vector2(0, 0))

		#newWire.add_wire_point(get_global_mouse_position() - global_position)
		globals.selectedOutput = get_parent().get_parent()
