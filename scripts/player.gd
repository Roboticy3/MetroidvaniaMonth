extends Node3D

func _enter_tree() -> void:
	#print("set authority of ", self, " in ", multiplayer.get_unique_id(), " to ", int(name))
	set_multiplayer_authority(int(name))

func check_health(value:float) -> void:
	if value <= 0.0:
		multiplayer.multiplayer_peer.close()
