class_name InputConfig extends Resource

@export var mapping:Array[InputActionConfig]

@export var mouse_sens:float
@export var controller_sens:float

func _to_string() -> String:
	var result := "InputConfig[\n\tmapping: [\n"
	for m in mapping:
		result += "\t\t" + str(m) + "\n"
	result += "\t], mouse_sens: " + str(mouse_sens) + ", controller_sens: " + str(controller_sens) + "]"
	return result
