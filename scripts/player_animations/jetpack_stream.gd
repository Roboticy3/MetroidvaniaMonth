extends AudioStreamPlayer3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	playing = get_parent().is_flying()
