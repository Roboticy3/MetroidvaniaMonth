
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

#Only accept environment changes from these users of the active group.
#Does nothing if left empty.
@export var accept_from_paths:Array[NodePath] = []
@onready var accept_from := accept_from_paths.map(get_node)

signal active_changed(to:bool)
signal activated()
signal deactivated()

func _ready():
	active = active

func _on_player_entered():
	print(self, " grabbing environment for player ?")
	
	if !accept_from.is_empty() and !(group.get_active() in accept_from):
		return
	
	grab()

func grab():
	group.grab(self)
