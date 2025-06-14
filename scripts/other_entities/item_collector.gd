##Triggerable function to collect items that should not respawn. Each of the 
##same `item_type` should have a unique `item_flag`, and vice-versa
##Also sends its global position through the `meta` argument of
##	`update_collectable` so the ui can show where the sprite is coming from.
extends Node3D

#The type of this item
@export var item_type:SaveData.ItemType
#A flag uniquely representing this item in the stage.
@export_range(0, 63) var item_flag:int

signal collected()

func collect():
	ClientState.save.update_collectable(item_type, item_flag, {"position":global_position})
	collected.emit()

func _ready():
	if ClientState.save.has_item(item_type, item_flag):
		collected.emit()
		queue_free() 
