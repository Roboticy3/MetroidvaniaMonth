@tool
## Assign non-overlapping item flags to all direct children so they can be 
## unique collectables.
extends Node

@export_tool_button("Assign Flags") var assign_flags := _on_assign_flags_pressed

func _on_assign_flags_pressed():
	var counts:PackedInt32Array = []
	counts.resize(SaveData.ItemType.TYPE_MAX)
	for c in get_tree().get_nodes_in_group("Collectable"):
		var type = c.get("item_type")
		if !(type is SaveData.ItemType): continue
		
		c.set("item_flag", counts[type])
		print("set item flag of ", c, " to ", counts[type])
		counts[type] += 1
		
		if counts[type] >= 64:
			print("WARNING: may have overloaded flag set for items of type ", type)
		
