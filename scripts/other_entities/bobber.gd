
extends Node3D

@export var spin := 2.0
@export var tilt := 0.25
@export var bob_amount := 0.25
@export var bob_speed := 4.0

@export var phase := 0.0

@export var use_physics_process := false :
	set(to):
		use_physics_process = to
		update_process_modes()

@onready var initial_position = position
@onready var initial_rotation = rotation

var count := 0.0

func _ready():
	update_process_modes()

func update_process_modes():
	if use_physics_process:
		set_physics_process(true)
		set_process(false)
	else:
		set_physics_process(false)
		set_process(true)

func _process(delta:float) -> void:
	tick(delta)
func _physics_process(delta: float) -> void:
	tick(delta)

func tick(delta:float) -> void:
	position = Vector3(0.0, bob_amount * sin(get_phase_time() * bob_speed), 0.0) + initial_position
	rotation = Vector3(tilt, spin * get_phase_time(), 0.0) + initial_rotation
	
	count += delta

func get_phase_time() -> float:
	return count + phase
