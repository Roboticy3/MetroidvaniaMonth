extends Node3D

@export var use_name_auth := true

func _enter_tree() -> void:
	#print("set authority of ", self, " in ", multiplayer.get_unique_id(), " to ", int(name))
	if use_name_auth: set_multiplayer_authority(int(name))
	
func check_health(value:float) -> void:
	print("recieved damage ", value)
	if value <= 0.0:
		if OS.get_name() == "Web":
			#Reload handled by ClientState unless offline
			get_tree().reload_current_scene.call_deferred()
		
		# evil magic spell from https://github.com/godotengine/godot/issues/77723 
		multiplayer.multiplayer_peer.close()
		
		
