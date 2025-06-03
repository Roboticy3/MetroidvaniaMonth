extends Label

@export var property := "velocity"
@export var target_group := "Entity"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	text = property.to_upper() + ": " + get_readout_value()

func get_readout_value() -> String:
	var result = ""
	
	for n in get_tree().get_nodes_in_group(target_group):
		result += n.name + " with " + str(n.get(property))
	return result if result != "" else "Unknown"
