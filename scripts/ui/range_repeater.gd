extends Label

@export var format := "{}%"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_value_changed(to:float) -> void:
	text = format.format([to], "{}")
