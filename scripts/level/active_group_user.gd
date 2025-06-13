
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
@export var footstep_sound:AudioStream = AudioStreamWAV.load_from_file("res://c78/Roland CR-78 Samples/BD/CR78 BD-01.wav")

signal active_changed(to:bool)
signal activated()
signal deactivated()

func _ready():
	print(group)
	if active:
		activated.emit() 
		grab()
	else:
		deactivated.emit()

func _on_player_entered():
	print(self, " grabbing environment for player ?")
	grab()

func grab():
	group.grab(self)
