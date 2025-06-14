extends Node

@export var object:PackedScene

func drop() -> void:
	add_child(object.instantiate())
