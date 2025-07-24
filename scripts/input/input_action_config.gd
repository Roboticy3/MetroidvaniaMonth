class_name InputActionConfig extends Resource

@export var name:StringName
@export var events:Array[InputEvent]

func _to_string() -> String:
	return "InputActionConfig[name: {}, {} events]".format(
		[name, events.size()], "{}"
	)
