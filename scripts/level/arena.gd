extends Node3D

var peer := ENetMultiplayerPeer.new()

@export var player_scene:PackedScene = load("res://scenes/player.tscn")

@export var previous_menu:PackedScene

func _ready():
	if ClientState.should_host: 
		host()
	else:
		join()
	
	multiplayer.server_disconnected.connect(_on_server_disconnected)

signal multiplayer_error(error:String)
signal player_connected(id:int)

func host() -> void:
	print("starting server on port ", ClientState.port)
	
	var error := peer.create_server(ClientState.port)
	if error != OK:
		multiplayer_error.emit("Failed to create server with error: ", error_string(error))
		return
	
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(1)

func _on_join_pressed() -> void:
	print("joining game. Reloading...")
	ClientState.should_host = false
	var error = get_tree().reload_current_scene()
	if error != OK:
		printerr("Failed to reload scene with error ", error_string(error))
		return

func join() -> void:
	print("joining server on port ", ClientState.port)
	
	var error:Error = peer.create_client("localhost", ClientState.port)
	if error != OK:
		multiplayer_error.emit("Failed to create client with error: " + error_string(error))
		
	multiplayer.multiplayer_peer = peer

#Generate a node name for players so they can be found later.
func generate_client_name(id:int) -> String:
	return str(id)

func add_player(id:int) -> void:
	print(multiplayer.get_unique_id(), " recieved call to add player with id ", id)
	var player := player_scene.instantiate()
	player.set("id_temp", id)
	
	player.name = generate_client_name(id)
	
	add_child(player)
	
	player_connected.emit(id)

func remove_player(id:int) -> void:
	var player_path := generate_client_name(id)
	var player = get_node_or_null(player_path)
	if player == null:
		printerr("Tried to disconnect player ", id, " from ", self, " with no child ", player_path)
		return
	player.queue_free()

func _on_server_disconnected():
	ClientState.should_host = true
	get_tree().reload_current_scene()
