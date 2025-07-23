extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visibility_changed.connect(grab_focus)
