## Shared progress state, including the serialized save resource as well as
## info on how to manage it and the server data

extends Node


var reset_save := false

func _ready():
	name = "Unnamed"
	
	var user_save:SaveData = load(SaveData.PATH)
	print("tried to load ", user_save, " at ", SaveData.PATH)

	if user_save and not reset_save:
		save = user_save
	else:
		save = load("res://save.tres")

var should_host = true

var client_rng := RandomNumberGenerator.new()
var url := "127.0.0.1"
var port := client_rng.randi_range(0,9999)

var save:SaveData
