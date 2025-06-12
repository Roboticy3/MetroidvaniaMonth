extends Node

func _ready():
	name = "Unnamed"

var should_host = true

var client_rng := RandomNumberGenerator.new()
var port := client_rng.randi_range(45192,65535)

var current_scene := ""

var save:SaveData = load("res://save.tres")
