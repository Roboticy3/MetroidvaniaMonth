## On `reveal_indicator`, reveal an indicator at the target position in world 
## 	space and tween it towards a target in screen space. 
## If this indicator is a transform child of another Node2D or Control,
##	to_screen can be local and is easily left to the default Vector2.ZERO, 
##	matching wherever the parent is placed.
extends Node2D

# Returns: a tween that ends when the indicator reaches its destination.
#	Useful for synchronizing ui updates with its callback
func reveal_indicator(at_world:Vector3, to_screen:=Vector2.ZERO) -> Tween:

	#Show the indicator and set its initial position on screen
	visible = true
	var camera := get_viewport().get_camera_3d()
	if camera:
		global_position = \
			camera.unproject_position(at_world)
	
	var tween_pos := create_tween()
	tween_pos.tween_property(self, "position", to_screen, 1)
	#attach callbacks to the position tween because I feel like it
	tween_pos.tween_callback(set_visible.bind(false))
	tween_pos.tween_callback(set_process.bind(false))
	
	#tween scale is technically longer so it can go to zero without erasing the 
	#	indicator too quickly
	var tween_scale := create_tween()
	tween_scale.tween_property(self, "scale", Vector2.ZERO, 2)
	
	return tween_pos
