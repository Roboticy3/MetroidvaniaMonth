
extends Node3D

@export var spin := 2.0
@export var tilt := 0.25
@export var bob_amount := 0.25
@export var bob_speed := 4.0

@onready var initial_position = position
@onready var initial_rotation = rotation

var count := 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = Vector3(0.0, bob_amount * sin(count * bob_speed), 0.0) + initial_position
	rotation = Vector3(tilt, spin * count, 0.0) + initial_rotation
	
	count += delta
