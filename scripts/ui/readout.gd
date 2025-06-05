extends Label

@export var property := "velocity"
@export var target_group := "Entity"
@export var use_node_path_instead_of_group := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	text = property.to_upper() + ": " + get_readout_value()

func get_nodes() -> Array[Node]:
	if use_node_path_instead_of_group:
		return [get_node(target_group)]
	else:
		return get_tree().get_nodes_in_group(target_group)

func get_readout_value() -> String:
	var result = ""
	
	for n in get_nodes():
		result += n.name + " with " + str(n.get(property))
	return result if result != "" else "Unknown"
