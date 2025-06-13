extends Node

func _ready():
	name = "Unnamed"
	
	var user_save := load(SaveData.PATH)
	print("tried to load ", user_save, " at ", SaveData.PATH)

	if user_save:
		save = user_save
	else:
		save = load("res://save.tres")

var should_host = true

var client_rng := RandomNumberGenerator.new()
var url := "127.0.0.1"
var port := client_rng.randi_range(0,9999)

var current_scene := ""

var save:SaveData
