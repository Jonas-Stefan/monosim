using Godot;
using System.Collections.Generic;



public partial class Graph: Resource
{
    public List<GraphNode> nodes;
    public List<GraphEdge> edges;

    public Graph(){
        nodes = new List<GraphNode>();
        edges = new List<GraphEdge>();
    }

    public void EvaluateEdges(){
        foreach(GraphEdge edge in edges){
            edge.output.inputs.Add(edge.input.state);
        }
    }

    public void EvaluateNodes(){
        foreach(GraphNode node in nodes){
            node.UpdateState();
        }
    }

    public void AddGraphNode(GraphNode node){
        nodes.Add(node);
    }

    public void AddGraphEdge(GraphEdge edge){
        edges.Add(edge);
    }

    public GraphNode GetNode(int index){
        return nodes[index];
    }

    public void RemoveEdge(GraphEdge edge){
        edges.Remove(edge);
    }

    public void RemoveNode(GraphNode node){
        nodes.Remove(node);
    }
}
