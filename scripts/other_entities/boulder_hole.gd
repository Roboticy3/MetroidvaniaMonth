extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered) # Replace with function body.

signal filled()
func _on_body_entered(body:Node3D):
	if body.is_in_group("Boulder") and body is RigidBody3D:
		var linear_tween := body.create_tween()
		linear_tween.tween_property(body, "linear_damp", 30.0, 2.0)
		
		var angular_tween := body.create_tween()
		angular_tween.tween_property(body, "angular_damp", 30.0, 2.0)
		
		print("hole filled by ", body, "!")
		filled.emit()
