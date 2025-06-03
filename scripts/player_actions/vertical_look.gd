extends Camera3D


const MAX_CAMERA_ANGLE_UNSIGNED := 80.0 * PI / 180.0

func _ready():
	if !is_multiplayer_authority():
		return
	
	current = true

func _on_look(angle:Vector2):
	if !is_multiplayer_authority():
		return
	rotation.x = clampf(angle.x, -MAX_CAMERA_ANGLE_UNSIGNED, MAX_CAMERA_ANGLE_UNSIGNED)
