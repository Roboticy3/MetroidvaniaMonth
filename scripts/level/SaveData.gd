extends Resource
class_name SaveData

@export var collectables:Array[int] = [0,0,0,0]

enum ItemType {
	SCREW = 0,
	SOUL,
	GUN,
	BEACON
}

signal collectable_updated(item_type:ItemType, item_flag:int)
func update_collectable(item_type:ItemType, item_flag:int) -> bool:
	#Check if `item_flag` is already collected in `item_type`
	var mask = 1 << item_flag
	if collectables[item_type] & mask:
		return false
	collectables[item_type] |= mask
	collectable_updated.emit(item_type, item_flag)
	ResourceSaver.save(self)
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
