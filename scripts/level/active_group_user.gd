
extends Node

@export var group:ActiveGroup :
	set(new_group):
		group = new_group
		active = active

@export var active:bool = true:
	set(to):
		if !active and to:
			activated.emit()
		elif active and !to:
			deactivated.emit()
		active = to
		active_changed.emit(to)

#Since this script is used for environments, use to send a footstep sound to the player
@export var footstep_sound:AudioStream

signal active_changed(to:bool)
signal activated()
signal deactivated()

func _ready():
	active = active

func _on_player_entered():
	print(self, " grabbing environment for player ?")
	grab()

func grab():
	group.grab(self)
