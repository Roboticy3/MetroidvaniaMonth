## Display the count of a certain item type from ClientState.save
extends Label

@export var item_type:SaveData.ItemType
var format := ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	format = text
	update_text()
	
	#Update the count every time an item is collected
	#_on_collectable_updated will check if the item is of the matching type to 
	#	register an update
	ClientState.save.collectable_updated.connect(_on_collectable_updated)

func _on_collectable_updated(
	incoming_type:SaveData.ItemType, _f:int, 
	meta:={"position":Vector3.ZERO}
):

	var reveal_at = meta.get("position")
	
	if incoming_type == item_type and reveal_at is Vector3:
		$Indicator\
		.reveal_indicator(reveal_at)\
		.tween_callback(update_text)
	else:
		update_text()

func update_text():
	text = format % ClientState.save.get_item_total(item_type)
