extends componentBase

var chipGraph: graph

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
	
	update_chip_resource()
	get_tree().get_root().get_node("root").chips.append(self)

func _process(delta):
	super._process(delta)

func update_chip_resource() -> void:
	#turn the information stored in the chipResource into a graph
	var graphNodes: Array[graphNode] = []
	var graphEdges: Array[graphEdge] = []

	for type in chipResource.gateTypes:
		var newNode: graphNode = graphNode.new(type)
		graphNodes.append(newNode)
	
	for edge in chipResource.gateEdges:
		var input: graphNode = graphNodes[edge[0]]
		var output: graphNode = graphNodes[edge[1]]
		var newEdge: graphEdge = graphEdge.new(input, output)
		graphEdges.append(newEdge)

	chipGraph = graph.new(graphNodes, graphEdges)



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
	#I will have to change it
	chipWidth *= 2
	$body.scale.x = max(0.2, chipWidth / 600)
	$body.modulate = chipResource.color
	$dragArea/shape.scale = $body.scale * 30

	

	#the code for the inputs and outpus is pretty similar, maybe I could make a function for that?

	#add the input pins according to the switches

	#position of the highest input
	var topPosY: float
	if chipResource.inputs.size() == 1:
		topPosY = 0
	elif chipResource.inputs.size() % 2 == 0:
		#even number of inputs
		topPosY = (chipResource.inputs.size() / 2.0 - 1.0) * -40 - 20
	else:
		topPosY = ((chipResource.inputs.size() - 1) / 2.0) * -40


	for i in range(chipResource.inputs.size()):
		var input: Node2D = load("res://Scenes/input.tscn").instantiate()
		input.position = Vector2(-chipWidth / 2.0, topPosY + i * 40)
		inputs.append(input)
		self.add_child(input)
	
	#add the output pins according to the lamps

	#position of the highest output
	if chipResource.outputs.size() == 1:
		topPosY = 0
	else:
		topPosY = (chipResource.outputs.size() / 2.0 - 1) * -40

	#decrease the position of the highest output by 20 if the number of outputs is even
	if chipResource.outputs.size() % 2 == 0 and chipResource.outputs.size() != 0:
		topPosY -= 20

	for i in range(chipResource.outputs.size()):
		var output: Node2D = load("res://Scenes/output.tscn").instantiate()
		output.position = Vector2(chipWidth / 2.0, topPosY + i * 40)
		outputs.append(output)
		self.add_child(output)
