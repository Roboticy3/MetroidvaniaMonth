extends AnimationPlayer

@export_node_path var player_path := NodePath("..")
@onready var player := get_node(player_path)

func _ready() -> void:
	animation_finished.connect( func (_a): 
		set_process(true)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player.is_stopped():
		play("Idle")
	else:
		play("Move")


func _on_shoot(_p, _id) -> void:
	stop()
	play("Fire", 0.0)
	set_process(false)
