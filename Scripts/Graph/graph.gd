class_name graph

var nodes: Array[graphNode] = []
var edges: Array[graphEdge] = []

func _init(_nodes: Array = [], _edges: Array = []) -> void:
    for node in _nodes:
        self.nodes.append(node)
    for edge in _edges:
        self.edges.append(edge)
    return

func evaluate() -> void:
    for edge in edges:
        edge.output.inputs.append(edge.input.state)
    
    #update all the nodes in the graph
    for node in nodes:
        node.update_state()