extends LineEdit

@export var state_property := "name"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_changed.connect(_on_text_changed)
	text = ClientState.get(state_property)
	wants_restart.emit(false)

signal wants_restart(yes:bool)

func _on_text_changed(new_string:String):
	var old_column := caret_column
	text = validate_string(new_string)
	caret_column = old_column
	ClientState.set(state_property, new_string)
	if multiplayer.has_multiplayer_peer():
		wants_restart.emit(true)

func validate_string(new_string) -> String:
	return StringName(new_string).validate_node_name().validate_filename()
