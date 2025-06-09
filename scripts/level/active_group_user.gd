
extends Node

@export var group:ActiveGroup :
	set(new_group):
		group = new_group
		active = active

@export var active:bool = true:
	set(to):
		active = to
		active_changed.emit(to)

signal active_changed(to:bool)

func _ready():
	if active: grab()

func _on_player_entered():
	print(self, " grabbing environment for player ?")
	grab()

func grab():
	group.grab(self)
