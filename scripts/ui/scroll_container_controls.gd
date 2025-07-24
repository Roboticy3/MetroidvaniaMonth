extends ScrollContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scroll_horizontal += Input.get_axis("LookLeft","LookRight")
	scroll_vertical += Input.get_axis("LookUp","LookDown")
	
	#print("scrolling ", scroll_vertical)
