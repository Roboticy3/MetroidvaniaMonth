@tool
## If children of this node, direct or indirect, have a name in the form of 
## "group-...", and "group" is a defined group, they will be added to the group
## and this change will be persisted.

## If lights come in with over 1000 watts of energy, they are divided by 1000

## If lights come in with "shadow" (case-insensitive) in their name, they are
## given shadows.

extends Node

@export_tool_button("Adjust Import") var adjust_import = _on_adjust_import_pressed

const window_mat_override := preload("res://Window-override.tres")

func _on_adjust_import_pressed():
	print("setting groups in hierarchy")
	
	correct_children_recursive(self)

func correct_children_recursive(of:Node):
	correct_children(of)
	for c in of.get_children():
		correct_children_recursive(c)

func correct_children(of:Node):
	for c in of.get_children():
		if c is Light3D:
			print("attempting to correct lightsource")
			if c.light_energy >= 50.0:
				c.light_energy = 1
			if c.name.containsn("shadow"):
				c.shadow_enabled = true
			
			if c is OmniLight3D:
				c.omni_range = 5
		
		var proposed_group := c.name.split("-",true)[0]
		if get_tree().has_group(proposed_group):
			print("added ", c, " to group ", proposed_group)
			if proposed_group == "Window": c.set("surface_material_override/0", window_mat_override)
			c.add_to_group(proposed_group, true)
