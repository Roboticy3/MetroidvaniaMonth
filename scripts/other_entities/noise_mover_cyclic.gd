extends Node

@export var noise:Noise
@export var speed := 1.0

var count := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	noise.offset += Vector3.ONE * delta * speed * sin(count)

	count += delta
