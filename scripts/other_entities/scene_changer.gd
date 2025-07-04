extends Node

const TARGETS:Array[PackedScene] = [
	preload("res://scenes/levels/main_menu.tscn"),
	preload("res://scenes/levels/full.tscn"),
	preload("res://scenes/levels/temple-test.tscn")
]
@export var target := 1

func _init():
	print(self, " init target: ", target)

func _ready():
	print(self, " ready target: ", target)

func _on_start_any_player_entered() -> void:
	change()

func change(t:=target):
	print(self, " change target: ", target)
	
	var packed = TARGETS[t]
	if !(packed is PackedScene):
		printerr("no target scene to change to!")
		return
	
	print("changing level on ", multiplayer.get_unique_id())
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	ClientState.current_scene = packed.resource_path
	var error := get_tree().change_scene_to_packed(packed)
	print("changed scene with error ", error_string(error))
