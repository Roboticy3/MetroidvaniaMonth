extends AudioStreamPlayer3D

const MIN_SPEED := 5.0
const SPEED_FACTOR := 4.5

@export_node_path("CharacterBody3D") var player_path := NodePath("../CharacterBody3D")
@onready var player:CharacterBody3D = get_node(player_path)

@export var environment_group:ActiveGroup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("my group: ", environment_group)
	environment_group.active_changed.connect(_on_environment_changed)
	_on_environment_changed(environment_group.get_active())

func _on_environment_changed(to:Node):
	if to == null: return
	var new_stream = to.get("footstep_sound")
	if !(new_stream is AudioStream): return
	print("changing stream")
	stop()
	stream = new_stream
	
var time_since_last_step := 0.0
func _process(delta:float) -> void:
	
	time_since_last_step += delta
	if player.is_on_floor():
		if time_since_last_step > time_between_footsteps():
			time_since_last_step = 0
			play_rpc.rpc()

@rpc("any_peer", "call_local", "reliable")
func play_rpc():
	play()

func time_between_footsteps() -> float:
	var speed:float = player.velocity_sync.length()
	if speed < MIN_SPEED:
		return INF
	return SPEED_FACTOR / (speed + 1.0)
