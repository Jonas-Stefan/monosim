extends Resource
class_name chipBase

#exporting everything so I can view it in the editor when debugging
@export var name: String
@export var color: Color
#the stuff needed to construct a graph
##the inputs of the chip
@export var inputs: Array
##the outputs of the chip
@export var outputs: Array[int]
##the types of the gates of the chip, so I can reconstruct the graph
@export var gateTypes: Array[String]
##the edges of the chip, in format [[inputNodeIndex, outputNodeIndex,], [inputNodeIndex, outputNodeIndex,]...]
@export var gateEdges: Array
