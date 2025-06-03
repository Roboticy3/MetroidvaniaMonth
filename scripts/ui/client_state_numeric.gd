extends SpinBox

@export var state_property := "port"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value_changed.connect(_on_value_changed)
	value = ClientState.get(state_property)

func _on_value_changed(new_value:float):
	ClientState.set(state_property, new_value)
