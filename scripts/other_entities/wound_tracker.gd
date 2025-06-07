extends Node

@export_node_path("Area3D") var player_detector_path
@onready var player_detector = get_node(player_detector_path)

signal wounds_depleted()

var wounds:Array[Node] = []
func _process(_delta: float) -> void:
	wounds = get_tree().get_nodes_in_group("Wound")
	if wounds.is_empty():
		#print("wounds depleted")
		wounds_depleted.emit()
		set_process(false)
		return
	
	for p in player_detector.players_inside:
		if p.is_multiplayer_authority():
			show_wounds()
			return
	hide_wounds()

func show_wounds():
	for w in wounds:
		if w is PhysicsBody3D:
			w.process_mode = Node.PROCESS_MODE_INHERIT
			w.visible = true

func hide_wounds():
	
	for w in wounds:
		if w is PhysicsBody3D:
			w.process_mode = Node.PROCESS_MODE_DISABLED
			w.visible = false
