@tool
extends AnimationPlayer


@export_tool_button("Check animation names") var check = _ready

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_animation_list())
