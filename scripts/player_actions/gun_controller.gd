extends Node3D

const SHOOT_TIME := 0.1
var time_since_last_shot := INF

func _ready():
	if !is_multiplayer_authority():
		set_process(false)
		set_process_unhandled_input(false)
		return
	
	shoot.connect(_on_shoot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	time_since_last_shot += delta

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Shoot") and time_since_last_shot >= SHOOT_TIME:
		shoot_rpc.rpc()

@rpc("any_peer", "call_local", "reliable")
func shoot_rpc():
	shoot.emit($Kickback, get_multiplayer_authority())
	time_since_last_shot = 0.0

signal shoot(caster, id:int)

@export_node_path var shooter_owner_path := NodePath("../..")
@onready var shooter_owner = get_node(shooter_owner_path)

const PUSH_FORCE := 50.0
func _on_shoot(p:ShapeCast3D, _id:int):
	
	for i in p.get_collision_count():
		
		var collider := p.get_collider(i)
		#print(collider)
		if collider.is_in_group("Entity") and collider != shooter_owner:
			collider.apply_central_impulse_rpc.rpc(global_basis.z * PUSH_FORCE)
