extends LineEdit

@export var state_property := "name"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_changed.connect(_on_text_changed)
	text = ClientState.get(state_property)

func _on_text_changed(new_string:String):
	text = validate_string(new_string)
	ClientState.set(state_property, new_string)

func validate_string(new_string) -> String:
	return StringName(new_string).validate_node_name().validate_filename()
