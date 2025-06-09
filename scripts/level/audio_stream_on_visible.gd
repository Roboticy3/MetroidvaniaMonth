## Unused! Old attempt at setting audio based on a visibility group
extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect("visibility_changed", _on_parent_visibility_changed)
	_on_parent_visibility_changed()

func _on_parent_visibility_changed() -> void:
	if get_parent().get("visible"):
		play()
	else:
		stop()
