extends Node

@export var target := 1

func change():
	print("changing to target ", target)
	SceneChanger.change(target)
