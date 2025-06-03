extends GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explosiveness = 1.0
	one_shot = true
	emitting = false

@onready var initial_position = position
func _on_shoot(_p, _id):
	
	(func ():
		restart()
		emitting = true
	).call_deferred()
