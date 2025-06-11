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
	if item_type != incoming_type: return

	$Indicator\
		.reveal_indicator(meta["position"])\
		.tween_callback(update_text)

func update_text():
	text = format % ClientState.save.get_item_total(item_type)
