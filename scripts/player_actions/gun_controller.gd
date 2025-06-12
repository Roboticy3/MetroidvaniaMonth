extends Node3D

const SHOOT_TIME := 0.1
var time_since_last_shot := INF

func _ready():
	if !is_multiplayer_authority():
		set_enabled(false)
		return
	
	shoot.connect(_on_shoot)

func set_enabled(to:bool):
	set_process(to)
	set_process_unhandled_input(to)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	time_since_last_shot += delta

func _unhandled_input(event: InputEvent) -> void:
	if ClientState.save.has_item(SaveData.ItemType.GUN, 0) and \
		 event.is_action_pressed("Shoot") and \
		time_since_last_shot >= SHOOT_TIME:
		shoot_rpc.rpc()

@rpc("any_peer", "call_local", "reliable")
func shoot_rpc():
	shoot.emit($Kickback, get_multiplayer_authority())
	time_since_last_shot = 0.0

signal shoot(caster, id:int)

@export_node_path var shooter_owner_path := NodePath("../..")
@onready var shooter_owner = get_node(shooter_owner_path)

const PUSH_FORCE := 50.0
var push_list:Array[Node3D] = []
func _physics_process(_delta: float) -> void:
	push_list = []
	var p:ShapeCast3D = $Kickback
	for i in p.get_collision_count():
		
		var collider := p.get_collider(i)
		
		#print(collider)
		if collider and collider.is_in_group("Entity") and collider != shooter_owner:
			#Unless the target is a boss wound, whose access is managed by the 
			#	boss to get around their colliders, cast a ray to the 
			#	target and don't add it to the push list if there's something 
			#	in the way. This way, the shape can still "pass" through narrow
			#	gaps without giving targets that look sussy
			if !collider.is_in_group("Wound") and !can_see_target(collider):
				continue
			
			push_list.append(collider)

func _on_shoot(_p:ShapeCast3D, _id:int):
	for c in push_list:
		c.apply_central_impulse_rpc.rpc(global_basis.z * PUSH_FORCE)

const OCCLUSION_TOLERANCE := 1.0
func can_see_target(to:Node3D) -> bool:
	# https://docs.godotengine.org/en/4.0/tutorials/physics/ray-casting.html
	var space_state := get_world_3d().direct_space_state
	# use global coordinates, not local to node
	var query := PhysicsRayQueryParameters3D.create(
		global_position,
		to.global_position,
		1
	)
	var result := space_state.intersect_ray(query)
	
	if result.is_empty(): return true
	
	var d := to.global_position.distance_to(result["position"])
	return d <= OCCLUSION_TOLERANCE
	
