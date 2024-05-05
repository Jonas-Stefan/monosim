using Godot;
using System;
using System.Collections.Generic;


public partial class SimEngine: Node
{
    private bool isRunning;
    public Graph mainGraph;
    public List<Graph> chipGraphs;
    public int ticksPerSecond;

    public SimEngine(){
        mainGraph = new Graph();
        chipGraphs = new List<Graph>();
        isRunning = false;
        ticksPerSecond = 10_000;
    }

    public void Start(){
        isRunning = true;
        MainLoop();
    }

    public void Stop(){
        isRunning = false;
    }

    public async void MainLoop(){
        while(isRunning){
            ulong startTime = Time.GetTicksUsec();

            //Change all the inputs of the graph nodes by evaluating the edges
            mainGraph.EvaluateEdges();
            foreach(Graph chipGraph in chipGraphs){
                chipGraph.EvaluateEdges();
            }

            //Update the state of all the nodes
            mainGraph.EvaluateNodes();
            foreach(Graph chipGraph in chipGraphs){
                chipGraph.EvaluateNodes();
            }

            //Wait for the current tick to end
            ulong opTime = Time.GetTicksUsec() - startTime;
            GD.Print("Operation time: " + opTime + "µs");
            float waitTimeSec = (float) Math.Max(0, (ulong) (1f / ticksPerSecond) - opTime / 1_000_000f);
            await ToSignal(GetTree().CreateTimer(waitTimeSec), "timeout");
        }
    }

    public void AddChipGraph(Graph chipGraph){
        chipGraphs.Add(chipGraph);
    }

    public void RemoveChipGraph(Graph chipGraph){
        chipGraphs.Remove(chipGraph);
    }
}
