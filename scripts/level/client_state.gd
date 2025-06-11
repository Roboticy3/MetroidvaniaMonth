extends Node

func _ready():
	name = "Unnamed"

var should_host = true
var port := 55555

var current_scene := ""

var save:SaveData = load("res://save.tres")
