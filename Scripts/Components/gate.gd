extends componentBase
class_name gateComponent

#this class is actually really boring... nothing much to see here

#export is neccecary!!! I changed the types in the editor
@export var type: String

func _ready():
	super._ready()
	#change the type of the node to the type of the gate
	node.type = type
	return


func _process(delta) -> void:
	super._process(delta)
	return
