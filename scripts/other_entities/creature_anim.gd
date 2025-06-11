extends AnimationPlayer

@export_node_path("CharacterBody3D") var creature_body_path := NodePath("../..")
@onready var creature_body:CharacterBody3D = get_node(creature_body_path)

func _ready():
	if !is_multiplayer_authority():
		set_process(false)
		return
	
	current_animation_changed.connect(_on_current_animation_changed)
	attack_disabled_set.emit(true)
	
func _on_current_animation_changed(new):
	if new == "Armature|Attack":
		attack_disabled_set.emit(false)
	else:
		attack_disabled_set.emit(true)

signal attack_disabled_set(disabled:bool)

# Called every frame. 'delta' is the elapsed time since the previous frame.
var dead := false
func _process(_delta: float) -> void:
	if dead: return
	if creature_body.is_too_close() and creature_body.is_facing_player():
		print("attacking")
		play("Armature|Attack")
	elif creature_body.is_on_floor() and current_animation != "Armature|Attack":
		play("Armature|Walk")
	else:
		stop()

func _on_character_body_3d_started_jump(direction: int) -> void:
	if direction == -1:
		play("Armature|Turn")
	else:
		play("Armature|TurnRight")

signal finished_death
func _on_wound_tracker_wounds_depleted() -> void:
	
	dead = true
	play("Armature|Death")
	animation_finished.connect((func (_a):
		set_process(false)
		active = false
		finished_death.emit()
	), CONNECT_ONE_SHOT)
