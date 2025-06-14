extends CanvasItem

func _unhandled_input(event: InputEvent) -> void:
	if !ClientState.save.has_item(SaveData.ItemType.BEACON, 0):
		return
	if event.is_action_pressed("Computer"):
		if visible:
			$AnimationPlayer.play_backwards("Open")
		else:
			$AnimationPlayer.play("Open")
