extends Area3D
var players_inside:Array[Node3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

signal player_entered(b:Node)
signal any_player_entered()
func _on_body_entered(b:Node) -> void:
	check_player_inside()
	if is_player_component(b):
		print("player entered ", self)
		player_entered.emit(b)
		any_player_entered.emit()

signal player_exited(b:Node)
func _on_body_exited(b:Node) -> void:
	check_player_inside()
	if is_player_component(b):
		player_exited.emit(b)
		

#redundantly check for players inside, so if multiple players are inside, and
#	one exits, `player_inside` can still be relied on.
func check_player_inside():
	players_inside = get_overlapping_bodies().filter(is_player_component)

func is_player_component(b:Node):
	return b.get_parent().is_in_group("Player")
