extends Node3D

@export_node_path("Area3D") var player_detector_path := NodePath("../../Range")
@onready var player_detector:Area3D = get_node(player_detector_path)

signal target_changed(to:Node3D)
var target = null :
	set(new_c):
		target = new_c
		target_changed.emit(new_c)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var inside:Array[Node3D] = player_detector.get("players_inside")
	if !(inside is Array[Node3D]):
		printerr("Target prioritizer is not hooked up to a player detector with the 'players_inside' array!")
	
	var temp = null
	for i in inside:
		#print("evaluating target ",i, " with score ", score_target(i))
		if score_target(i) < score_target(temp):
			temp = i
	if temp != target: target = temp

func score_target(i:Node3D) -> float:
	if !is_instance_valid(i) or !(i is Node3D): return INF
	var v := to_local(i.global_position)
	return v.length()
