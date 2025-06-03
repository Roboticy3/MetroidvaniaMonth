extends RigidBody3D

@rpc("any_peer", "call_local", "reliable")
func apply_central_impulse_rpc(impulse:Vector3):
	apply_central_impulse(impulse)
