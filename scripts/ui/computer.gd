extends CanvasItem

func _ready() -> void:
	ClientState.save.collectable_updated.connect(_on_collectable_updated)

func _on_collectable_updated(type:SaveData.ItemType, flag:int, _meta:Dictionary):
	if type == SaveData.ItemType.BEACON and flag == 0:
		toggle()

func _unhandled_input(event: InputEvent) -> void:
	if !ClientState.save.has_item(SaveData.ItemType.BEACON, 0):
		return
	if event.is_action_pressed("Computer"):
		toggle()

func toggle():
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		$AnimationPlayer.play_backwards("Open")
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		$AnimationPlayer.play("Open")
