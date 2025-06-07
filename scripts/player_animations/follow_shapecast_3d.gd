## Move a reticle to the gun target.

extends Node3D

@export_node_path("Node") var emitter_path := NodePath("..")
@onready var emitter = get_node(emitter_path)

func _ready():
	#Technically a ui element
	if !is_multiplayer_authority():
		set_process(false)
		visible = false
		return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Only set a position if there is a valid list of objects the gun wants to
	#	push.
	var push_list:Array[Node3D] = emitter.push_list
	if push_list.is_empty(): 
		visible = false
		return
	
	visible = true
	var viewer := get_viewport().get_camera_3d()
	
	var candidate_distance := INF
	var candidate:Node3D = null
	for p in push_list:
		if !is_instance_valid(p): continue
		var screen_pos := viewer.unproject_position(p.global_position)
		var center_distance := screen_pos.distance_to(Vector2(.5,.5))
		if center_distance < candidate_distance:
			candidate = p
			candidate_distance = center_distance
	
	if candidate == null: return
	
	global_transform = candidate.global_transform
