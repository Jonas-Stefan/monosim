using Godot;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;


public partial class SimEngine: Node
{
	private Thread loopThread;
	public Graph mainGraph;
	public List<Graph> chipGraphs;
	public int ticksPerSecond;
	public bool isTPSRestrictionEnabled;

	public SimEngine(){
		mainGraph = new Graph();
		chipGraphs = new List<Graph>();
		/*
		There (maybe) is a small problem with tps restriction, because the minimum value for basically all wait functions is 1ms. The engine is well capable of running at 1_000_000+ tps with a small circuit though, 
		so tps restriction will restrict the engine to a fraction of its potential. I am not sure if this is a problem though, because if you are running a small curcuit, 
		you probably won't notice the difference between 1_000_000 tps or even 100 tps, and when you have a giant curcuit, the engine will be running close to 1_000 tps anyway (I haven't tested this, but I think it will be close to that number).
		If you want to disable the restriction (maybe I will even implement this as a feature), go ahead, I just enabled it to protect the CPU.
		*/
		ticksPerSecond = 1_000;
		isTPSRestrictionEnabled = true;
	}

	public void Start(){
		//Start the main loop
		loopThread = new Thread(MainLoop);
		loopThread.Start();
	}

	public void Stop(){
		//Stop the main loop
		loopThread.Join();
		loopThread = null;
	}

	public void MainLoop(){
		//The core of the engine, this simulates the behavior of the circuit.
		while(true){
			Stopwatch sw = Stopwatch.StartNew();
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

			//Wait for the next tick, if the tps restriction is enabled and the tps are lower than 1_000, else just wait 1ms (This essentially caps the tps to 1_000)
			int waitTimeSec = (int) (1f / ticksPerSecond * 1000 - sw.ElapsedMilliseconds);
			if(isTPSRestrictionEnabled) Thread.Sleep(waitTimeSec > 0 ? waitTimeSec : 1);
		}
	}

	/*
	Some methods that are meant for GDscript.
	*/


	public void AddChipGraph(Graph chipGraph){
		chipGraphs.Add(chipGraph);
	}

	public void RemoveChipGraph(Graph chipGraph){
		chipGraphs.Remove(chipGraph);
	}
	
	public Godot.Collections.Array<Graph> GetChipGraphs(){
		return new Godot.Collections.Array<Graph>(chipGraphs);
	}
}
