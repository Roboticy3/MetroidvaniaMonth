extends Area3D

@export var sun_color:Color

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(b) -> void:
	if b.get_parent().is_in_group("Player"):
		print("changing env")
		change_environment()

func change_environment():
	for s in get_tree().get_nodes_in_group("Sun"):
		print(s)
		if s is DirectionalLight3D and s.shadow_enabled:
			print("changed color of ", s, " to ", sun_color)
			s.light_color = sun_color
