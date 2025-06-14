extends RigidBody3D

@export var local_push_direction := Vector3.BACK

func _on_relay(impulse:Vector3):
	
	if !local_push_direction.is_zero_approx():
		var redirected := global_transform.basis * local_push_direction * impulse.length()

		apply_central_impulse(redirected)
	else:
		apply_central_impulse(impulse)
