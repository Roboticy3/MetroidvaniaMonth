extends Range

#The efficiency divides delta when draining and multiplies it when filling.
@export var efficiency := 0.5

#The horizontal aspect ratio of 1 unit of this range, effects size.x
@export var fuel_unit_visual_aspect := 2.0

var inner_maximum := 0.0

@export var level := 0 : 
	set(new_level):
		level = new_level
		inner_maximum = new_level + 1

func update_visual_length():
	size.x = size.y * (max_value - min_value) * fuel_unit_visual_aspect 
	
func _ready():
	level = level

# Called every frame. 'delta' is the elapsed time since the previous frame.
func drain(delta: float) -> void:
	value -= delta / efficiency

func is_empty() -> bool:
	return value <= 0.0

func fill(delta):
	value += delta * efficiency
	if value >= inner_maximum:
		value = inner_maximum
