
extends Node

@export var group:VisibilityGroup :
	set(new_group):
		group = new_group
		_ready()

func _ready():
	group.add_user(self)
	if get("visible"):
		group.grab_visibility(self)
	connect("visibility_changed", _on_visibility_changed)

func _on_visibility_changed() -> void:
	print("visibility changed in user ", self, " of group ", group.users)
	if get("visible"): group.grab_visibility(self)
