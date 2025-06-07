## Display the count of a certain item.
extends Label

@export var item_type:SaveData.ItemType
var format := ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	format = text
	update_text()
	ClientState.save.collectable_updated.connect(_on_collectable_updated)

func _on_collectable_updated(incoming_type:SaveData.ItemType, _f:int):
	if item_type == incoming_type:
		update_text()

func update_text():
	text = format % ClientState.save.get_item_total(item_type)
