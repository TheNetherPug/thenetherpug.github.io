"""
▒█▀▀▀█ ▒█▀▀▀ ▒█▀▀█ ▀▀█▀▀ ▀█▀ ▒█▀▀▀█ ▒█▄░▒█
░▀▀▀▄▄ ▒█▀▀▀ ▒█░░░ ░▒█░░ ▒█░ ▒█░░▒█ ▒█▒█▒█
▒█▄▄▄█ ▒█▄▄▄ ▒█▄▄█ ░▒█░░ ▄█▄ ▒█▄▄▄█ ▒█░░▀█

▒█▀▀█ ▒█▀▀▀█ ▒█▀▄▀█ ▒█▀▀█ ▒█░░░ ▒█▀▀▀ ▀▀█▀▀ ▒█▀▀▀ ▒█▀▀█ 
▒█░░░ ▒█░░▒█ ▒█▒█▒█ ▒█▄▄█ ▒█░░░ ▒█▀▀▀ ░▒█░░ ▒█▀▀▀ ▒█▄▄▀ 
▒█▄▄█ ▒█▄▄▄█ ▒█░░▒█ ▒█░░░ ▒█▄▄█ ▒█▄▄▄ ░▒█░░ ▒█▄▄▄ ▒█░▒█

By @thenetherpug, for Envisagement.

A simple node similar to a countdown panel utilising signals for customizability.

What is a signal?
	A signal is a message sent out by one Node in Godot to another node.
	When the other node receives the signal, it carries out a function.
	
	E.g. A spatial node can emit a signal when it is ready
		for another note to play a cutscene animation. 

Properties: 
	Disabled (bool) - Disables processing if enabled.
	Required Amount (int) - The required amount of panels to be solved to complete.
	Nodes (array) - The array of panels to be checked.
	Process At (float) - How often to check the panels. The lower, the faster. 
						 You probably don't need to change this.
	
Usage:
	1. Add the panels you wish to be counted to the nodes array;
	2. Select the amount of completed panels required to activate completion;
	3. Navigate to the Signals tab of the right-hand inspector panel.
	4. Click on completed, and select the node you wish to run a function on.
	5. Type in the name of the function, optionally add parameters with the Advanced button.
	6. Click connect!
"""

tool
extends Node
class_name SectionCompleter
signal completed
signal amountChanged(amount)

export var disabled: bool = false
export var requiredAmount: int = 0
export var nodes: Array = [] setget setNodes, getNodes
export var processAt: float = 0.5

func _ready():
	add_to_group("highDetail") # disregard this if it's not envisagement :3
	

func _(): 
	return false
	
func setNodes(value):
	nodes = value
	
	for i in nodes.size():
		if nodes[i] != null: continue
		nodes[i] = NodePath("")
		
func getNodes():
	return nodes

var time: float = 0

var completed: bool = false

var completedCount: int = 0
func _process(delta):
	if disabled: return
	if completed: return
	time += delta
	if time < processAt: return
	
	var amount = 0
	time = 0
	
	for i in nodes:
		if get_node(i).is_complete:
			amount += 1
	
	if completedCount != amount:
		emit_signal("amountChanged", amount)
	if completedCount >= requiredAmount:
		completed = true
		emit_signal("completed")
		disabled = true
