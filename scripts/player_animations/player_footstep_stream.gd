extends AudioStreamPlayer3D

const MIN_SPEED := 5.0
const SPEED_FACTOR := 4.5

@export_node_path("CharacterBody3D") var player_path := NodePath("..")
@onready var player:CharacterBody3D = get_node(player_path)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
var time_since_last_step := 0.0
func _process(delta:float) -> void:
	time_since_last_step += delta
	if player.is_on_floor():
		if time_since_last_step > time_between_footsteps():
			time_since_last_step = 0
			play()

func time_between_footsteps() -> float:
	var speed:float = player.velocity_sync.length()
	if speed < MIN_SPEED:
		return INF
	return SPEED_FACTOR / (speed + 1.0)
