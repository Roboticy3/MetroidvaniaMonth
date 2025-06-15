extends Node

@export var target:PackedScene

func _on_start_any_player_entered() -> void:
	change()

func change():
	
	if !target:
		printerr("no target scene to change to!")
		return
	
	print("changing level on ", multiplayer.get_unique_id())
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	ClientState.current_scene = target.resource_path
	get_tree().change_scene_to_packed(target)
