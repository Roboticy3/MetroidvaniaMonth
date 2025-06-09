extends Node
@export var properties:Dictionary[StringName, Variant] = {
	"current": true
}

func _ready():
	if is_multiplayer_authority():
		for k in properties:
			var v = properties[k]
			set(k,v)
