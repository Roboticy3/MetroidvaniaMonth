extends AnimationPlayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	speed_scale = get_parent().speed_scale
	if get_parent().current_animation == "Armature|Walk":
		play("MaterialEffects|Walk")
