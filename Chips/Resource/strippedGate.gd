extends Resource
class_name strippedGate

# a abstract representation of a gate, that is used in chips
@export var type: String
@export var state: bool = false
@export var inputs: Array