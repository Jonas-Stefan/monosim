extends Resource
class_name chipBase

#exporting everything so I can view it in the editor when debugging
@export var name: String
@export var color: Color
@export var gates: Array[strippedGate] = []
# @export var chips: Array[chipBase] = []
@export var inputs: int
@export var outputs: Array
