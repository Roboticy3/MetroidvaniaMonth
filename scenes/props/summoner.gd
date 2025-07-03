extends Node3D

@export var scene:PackedScene

func summon():
	add_child(scene.instantiate())
