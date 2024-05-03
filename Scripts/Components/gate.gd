extends componentBase
class_name gateComponent

#export is neccecary!!! I changed the types in the editor
@export var type: String

func _ready():
	super._ready()


func _process(delta) -> void:
	super._process(delta)
	
	#change the type of the node to the type of the gate
	node.type = type
	return
