extends AudioStreamPlayer3D

@export_node_path("CharacterBody3D") var player_path := NodePath("../CharacterBody3D")
@onready var player:CharacterBody3D = get_node(player_path)

func _ready():
	if !is_multiplayer_authority():
		set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.is_flying() and !playing:
		play_rpc.rpc()
	elif !player.is_flying() and playing:
		stop_rpc.rpc()

@rpc("any_peer", "call_local", "reliable")
func play_rpc():
	#print("playing jetpack sound on ", multiplayer.get_unique_id())
	play()

@rpc("any_peer", "call_local", "reliable")
func stop_rpc():
	#print("stopping jetpack sound on ", multiplayer.get_unique_id())
	stop()
