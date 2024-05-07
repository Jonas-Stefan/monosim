using Godot;
using System.Collections.Generic;

public partial class GraphNode: Node
{
	public string type;
	public List<bool> inputs;
	public bool state;

	public GraphNode(){
		type = "";
		inputs = new List<bool>();
		state = false;
	}

	public void UpdateState(){
		if(type == "AND"){
			FillInputs(2);
			state = inputs[0] && inputs[1];
		}else if(type == "OR"){
			FillInputs(2);
			state = inputs[0] || inputs[1];
		}else if(type == "NOT"){
			FillInputs(1);
			state = !inputs[0];
		}else if(type == "lamp"){
			FillInputs(1);
			state = inputs[0];
		}

		inputs.Clear();
	}

	public void FillInputs(int inputCount){
		for(int i = inputs.Count; i < inputCount; i++){
			inputs.Add(false);
		}
	}
}
