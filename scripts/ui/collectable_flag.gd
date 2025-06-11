extends Node

@export var item_type:SaveData.ItemType
@export var item_flag:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_enabled(ClientState.save.has_item(item_type, item_flag))
	ClientState.save.collectable_updated.connect(_on_collectable_updated)

func _on_collectable_updated(incoming_type:SaveData.ItemType, incoming_flag:int, meta:Dictionary):
	if item_type == incoming_type and item_flag == incoming_flag:
		set_enabled(true)
	
		if $Indicator:
			$Indicator.reveal_indicator(meta["position"])


func set_enabled(to:bool):
	set("visible", to)
	set_process(to)
	set_process_unhandled_input(to)
