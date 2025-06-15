extends Range

#The efficiency divides delta when draining and multiplies it when filling.
@export var efficiency := 0.5

#The horizontal aspect ratio of 1 unit of this range, effects size.x
@export var fuel_unit_visual_aspect := 2.0

@export var debounce_drain := 0.0
var invincible := false
var invincible_timer:Timer

var inner_maximum := 0.0

@export var level := 0 : 
	set(new_level):
		level = new_level
		inner_maximum = new_level + 1
		print("set max to ", inner_maximum)

func update_visual_length():
	size.x = size.y * (max_value - min_value) * fuel_unit_visual_aspect 
	
func _ready():
	level = level
	
	if debounce_drain > 0.0:
		var timer = Timer.new()
		timer.autostart = false
		timer.wait_time = debounce_drain
		timer.one_shot = true
		timer.timeout.connect(func ():
			invincible = false
			print("bruh")
		)
		add_child(timer)
		invincible_timer = timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func drain(delta: float) -> void:
	if !invincible:
		value -= delta / efficiency
		if debounce_drain > 0.0:
			print("debouncing drain with ", debounce_drain, " seconds")
			invincible = true
			invincible_timer.start(debounce_drain)

func is_empty() -> bool:
	return value <= 0.0

func fill(delta):
	value += delta * efficiency * (level + 1) * 4.0
	if value >= inner_maximum:
		value = inner_maximum
