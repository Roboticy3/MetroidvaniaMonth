## Track save data for the game. Each item type has a bitmask describing which
## items are in the possession of the player, and which are not. This reserves 
## plenty of each type of item while giving the game a means to identify which
## items have been previously collected.
extends Resource
class_name SaveData

@export var collectables:Array[int] = [0,0,0,0]

enum ItemType {
	SCREW = 0,
	SOUL,
	GUN,
	BEACON
}

#Users can connect to this signal to be notified when an item is picked up.
#	The `meta` argument is anything the caller wants the users to know, such as
#	the position in world space where an item was found.
signal collectable_updated(item_type:ItemType, item_flag:int, meta:Dictionary)
func update_collectable(item_type:ItemType, item_flag:int, meta:={}) -> bool:
	#Check if `item_flag` is already collected in `item_type`
	var mask = 1 << item_flag
	if collectables[item_type] & mask:
		return false
	collectables[item_type] |= mask
	collectable_updated.emit(item_type, item_flag, meta)
	#ResourceSaver.save(self)
	return true

#Count the number of active flags in a certain `item_type`
func get_item_total(item_type:ItemType) -> int:
	var count = 0
	var shift = collectables[item_type]
	while shift:
		count += shift & 1
		shift = shift >> 1
	return count

func has_item(item_type:ItemType, item_flag:int):
	return collectables[item_type] & (1 << item_flag)
