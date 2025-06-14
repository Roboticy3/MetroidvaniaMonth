
extends Area3D

@export var force := Vector3.ZERO

func _ready():
	body_entered.connect(_on_body_entered)

signal entity_found()

func _on_body_entered(b:Node):
	if b.is_in_group("Entity"):
		entity_found.emit()
