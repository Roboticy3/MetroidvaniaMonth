##Triggerable function to collect items that should not respawn. Each of the 
##same `item_type` should have a unique `item_flag`, and vice-versa
extends Node

#The type of this item
@export var item_type:SaveData.ItemType
#A flag uniquely representing this item in the stage.
@export_range(0, 63) var item_flag:int

func collect():
	ClientState.save.update_collectable(item_type, item_flag)

func _ready():
	if ClientState.save.has_item(item_type, item_flag):
		queue_free()
