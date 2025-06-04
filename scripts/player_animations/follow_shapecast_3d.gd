## Move a reticle to the gun target.

extends Node3D

@export_node_path("Node") var emitter_path := NodePath("..")
@onready var emitter = get_node(emitter_path)

var frame_count := 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Only set a position if there is a valid list of objects the gun wants to
	#	push.
	var push_list:Array[Node] = emitter.push_list
	if push_list.is_empty(): 
		visible = false
		return
	
	visible = true
	
	var target = frame_count % push_list.size()
	#Since gun targets often disappear, check they still exist before reading
	#	information from them.
	if !is_instance_valid(push_list[target]):
		return
	
	frame_count += 1
	
	global_transform = push_list[target].global_transform
