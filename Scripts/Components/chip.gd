extends componentBase

var chipGraph

@export var chipResource: chipBase:
	set(value):
		chipResource = value

		update_chip_resource()

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

	#remove the inputs and outputs added by the componentBase constructor
	for i in range(inputs.size()):
		inputs[0].queue_free()
		inputs.remove_at(0)
	for i in range(outputs.size()):
		outputs[0].queue_free()
		outputs.remove_at(0)
	
	#update the chip resource and add the chipGraph to the simulation
	update_chip_resource()
	SimEngine.AddChipGraph(chipGraph)

	#remove the unneeded node that got added by componentBase
	SimEngine.mainGraph.RemoveNode(node)

	#add the chip to the global chip list
	get_tree().get_root().get_node("root").chips.append(self)

func _process(delta):
	super._process(delta)

func delete():
	#override the delete function to remove the chipGraph from the simulation
	SimEngine.RemoveChipGraph(chipGraph)
	super.delete()

func update_chip_resource() -> void:
	#turn the information stored in the chipResource into a graph
	var graphNodes: Array = []
	var graphEdges: Array = []

	#add the nodes and edges to the graph
	for type in chipResource.gateTypes:
		var newNode = globals.graphNode.new()
		newNode.type = type
		graphNodes.append(newNode)
	for edge in chipResource.gateEdges:
		var newEdge = globals.graphEdge.new()
		newEdge.input = graphNodes[edge[0]]
		newEdge.output = graphNodes[edge[1]]
		graphEdges.append(newEdge)

	#create the chipGraph
	chipGraph = globals.graph.new()
	for _node in graphNodes:
		chipGraph.AddGraphNode(_node)
	for _edge in graphEdges:
		chipGraph.AddGraphEdge(_edge)

	#reset the inputs and outputs
	for i in range(inputs.size()):
		inputs[i].queue_free()
		inputs.remove_at(i)
	for i in range(outputs.size()):
		outputs[i].queue_free()
		outputs.remove_at(i)


	#change the appearance of the chip according to the chipResource
	$Label.text = chipResource.name
	$body.scale.y = max(0.2, max(chipResource.inputs.size() * 0.067, chipResource.outputs.size() * 0.067))
	var chipWidth: float = $Label.size.x + 40
	chipWidth /= 2
	chipWidth = globals.snap_to_grid(Vector2(chipWidth, 0)).x
	chipWidth *= 2
	$body.scale.x = max(0.2, chipWidth / 600)
	$body.modulate = chipResource.color
	$dragArea/shape.scale = $body.scale * 30

	

	#the code for the inputs and outpus is pretty similar, maybe I could make a function for that?

	#add the input pins according to the switches

	#position of the highest input
	var topPosY: float = get_highest_pin_pos(chipResource.inputs.size())

	#create and add the input pins
	for i in range(chipResource.inputs.size()):
		var input: Node2D = load("res://Scenes/input.tscn").instantiate()
		input.position = Vector2(-chipWidth / 2.0, topPosY + i * 40)
		inputs.append(input)
		self.add_child(input)
	
	#add the output pins according to the lamps

	#position of the highest output
	topPosY = get_highest_pin_pos(chipResource.outputs.size())

	#create and add the output pins
	for i in range(chipResource.outputs.size()):
		var output: Node2D = load("res://Scenes/output.tscn").instantiate()
		output.position = Vector2(chipWidth / 2.0, topPosY + i * 40)
		outputs.append(output)
		self.add_child(output)

func get_highest_pin_pos(pinCount: int) -> float:
	if pinCount == 1:
		return 0
	elif pinCount % 2 == 0:
		return (pinCount / 2.0 - 1) * -40 - 20
	else:
		return ((pinCount - 1) / 2.0) * -40