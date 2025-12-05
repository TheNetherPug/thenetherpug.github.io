"""

░█▀▀█ ▀▀█▀▀ ▀▀█▀▀ ░█▀▀█ ▒█▀▀█ ▒█░▒█ ▒█▀▀▀ ▒█▀▀█ 
▒█▄▄█ ░▒█░░ ░▒█░░ ▒█▄▄█ ▒█░░░ ▒█▀▀█ ▒█▀▀▀ ▒█▄▄▀ 
▒█░▒█ ░▒█░░ ░▒█░░ ▒█░▒█ ▒█▄▄█ ▒█░▒█ ▒█▄▄▄ ▒█░▒█
by @thenetherpug

A simple one-script tool that lets you attach other nodes to GridMap cells based on the mesh.

Usage:
	1. Add this script to a blank Node in your scene.
	2. Select the mesh index of the mesh you would like to add a node to all instances of.
	3. Click "Add Attachment To List".
	4. Under the Attachments Dictionary, you will now see a new key with the desired index.
	5. Create a spatial node, and place the rest of the nodes you want attached under that spatial node.
	6. Drag and drop that spatial node onto the Assign button in the newly created key.
	7. Click Attach Nodes, and you're done!
	
To remove an index, simply type it into the Index value and click Remove Attachment From List.

NOTE: Everytime you add new blocks to the GridMap, or update an attachment, you have to press Attach once more to recreate the attachments.
	
Detach nodes just detaches them.
"""

# I wrote this in 20 minutes lmfao

tool
extends Node
export var gridMapPath: NodePath = NodePath("")
export var attachments: Dictionary = {} setget setAttachments, getAttachments
export var index: int = 0
export var addAttachmentToList: bool = false setget addAttachment, _
export var removeAttachmentFromList: bool = false setget removeAttachment, _

export var ATTACH_NODES: bool = false setget attach, _
export var DETACH_NODES: bool = false setget detach, _

func setAttachments(value):
	if !Engine.editor_hint: return
	attachments = value
	
	for x in attachments.keys():
		for y in attachments[x].size():
			if attachments[x][y] != null: continue
			attachments[x][y] = NodePath("")
			
func addAttachment(value):
	if !Engine.editor_hint: return
	attachments.merge({
		
		index: [NodePath("")],
		
	})
	property_list_changed_notify()
	
func removeAttachment(value):
	if !Engine.editor_hint: return
	attachments.erase(index)
	property_list_changed_notify()

func getAttachments():
	return attachments
	
func attach(value):
	if !Engine.editor_hint: return
	if !value: return
	
	detach(true)
	
	var gridMap: GridMap = get_node_or_null(gridMapPath)
	if !gridMap:
		printerr("[GRIDMAP ATTATCHER] GridMap path is invalid!")
		return
	
	
	var meshList: Array = gridMap.get_meshes()
	
	for i in attachments.keys():
		# ensure mesh exists
		if not i in gridMap.mesh_library.get_item_list(): continue
		var mesh: Mesh = gridMap.mesh_library.get_item_mesh(i) # grab mesh
		
		for j in meshList.size():
			if not meshList[j] is Mesh: continue
			if meshList[j] != mesh: continue
			
			var transform: Transform = meshList[j - 1]
	
			for attachPath in attachments[i]:
				var node = get_node_or_null(attachPath)
				if !node:
					printerr("A Node path is invalid for ", i)
					continue
				
				var duplicate = node.duplicate(8)
				
				add_child(duplicate)
				duplicate.set_owner(get_tree().edited_scene_root)
				
				duplicate.global_transform = transform
	
func detach(value):
	if !Engine.editor_hint: return
	if !value: return
	
	for i in get_children():
		i.queue_free()
	
func _():
	return false
