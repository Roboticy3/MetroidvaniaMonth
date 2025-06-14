## Take an impulse from the gun and converts it to a signal. The trigger
## disappears after shot.

extends PhysicsBody3D 

signal trigger()
signal relay(impulse:Vector3)

@rpc("any_peer", "call_local", "reliable")
func apply_central_impulse_rpc(_impulse:Vector3):
	trigger.emit()
	relay.emit(_impulse)
