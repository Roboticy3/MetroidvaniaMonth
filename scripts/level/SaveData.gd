## items are in the possession of the player, and which are not. This reserves 
## Track save data for the game. Each item type has a bitmask describing which
## plenty of each type of item while giving the game a means to identify which
## items have been previously collected.

## There are also ranges for things like completion percent or volume.
extends Resource
class_name SaveData

const PATH := "user://save.tres"

#Change this variable to false to disable saving to disk.
@export var live := true :
	set(to):
		live = to
		if to:
			print("WARNING: SaveData is now live and will write to disk when changed.")
		else:
			print("WARNING: SaveData is no longer live and will not write to disk when changed.")

@export var collectables:Array[int] = [0,0,0,0]

enum ItemType {
	SCREW = 0, #Screws
	SOUL, #Boss souls
	GUN, #Weapons
	BEACON, #Notes beacons
	LADDER, #Droppable ladder shortcuts
	PARTS, #Ship parts
	TYPE_MAX,
}

#Users can connect to this signal to be notified when an item is picked up.
#	The `meta` argument is anything the caller wants the users to know, such as
#	the position in world space where an item was found.
signal collectable_updated(item_type:ItemType, item_flag:int, meta:Dictionary)
func update_collectable(item_type:ItemType, item_flag:int, meta:={}) -> bool:
	#Check if `item_flag` is already collected in `item_type`
	var mask = 1 << item_flag
	if item_type >= collectables.size():
		collectables.resize(item_type + 1)
	
	if collectables[item_type] & mask:
		return false
	collectables[item_type] |= mask
	collectable_updated.emit(item_type, item_flag, meta)
	save()
	return true

#Count the number of active flags in a certain `item_type`
func get_item_total(item_type:ItemType) -> int:
	if item_type >= collectables.size():
		collectables.resize(item_type + 1)
	
	var count = 0
	var shift = collectables[item_type]
	while shift:
		count += shift & 1
		shift = shift >> 1
	return count

func has_item(item_type:ItemType, item_flag:int) -> int:
	if item_type >= collectables.size():
		collectables.resize(item_type + 1)
	
	return collectables[item_type] & (1 << item_flag)

func get_flags(item_type:ItemType) -> int:
	if item_type >= collectables.size():
		collectables.resize(item_type + 1)
	
	return collectables[item_type]

func clear_items() -> void:
	for i in collectables.size():
		collectables[i] = 0
	collectable_updated.emit(-1, -1, {})
	save()
	

@export var ranges:PackedFloat32Array =[
	100.0,
	0.0, #spawn x
	0.0, #spawn y
	0.0  #spawn z
]

enum RangeType {
	VOLUME = 0,
	SPAWNX,
	SPAWNY,
	SPAWNZ
}

func update_range(type:RangeType, value:float):
	ranges[type] = value
	save()

func get_range(type:RangeType) -> float:
	return ranges[type]

func save() -> void:
	if !live: return
	print("saving to ", PATH)
	var error := ResourceSaver.save(self, PATH)
	print("saved with error code ", error_string(error))
