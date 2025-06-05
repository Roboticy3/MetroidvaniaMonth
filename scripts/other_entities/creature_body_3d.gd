## Boss #1's movement. Move towards the host and attack them. 
## Forces the player to unlock the gun, and multiplayer, to kill.
## On the back are 3 wounds that will signal damage to a healthbar, this script
## 	just needs to take care of the movement.
## To stop the player from getting behind the boss wihtout the rotation looking 
##	too awkward, perform a jump away from the player.
extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 50.0
const JUMP_HORIZONTAL_VELOCITY = 15.0

## Turning speed scales between these two values, from 0 at MIN_TARGET to 0.5 at
##	MIN_FAST.
## MIN_TARGET is also the "attack range" of the boss. It will stop following in
## this range to attack.
const MIN_TARGET_DISTANCE := 5.0
const MIN_FAST_ROTATE_DISTANCE := 150.0

const AERIAL_ROTATION_BOOST := 15.0

# functions for setting target based off of player detector triggers
var target:Node3D
func _on_range_player_entered(new_target:Node3D):
	if !new_target.multiplayer.is_server(): return
	target = new_target
func _on_range_player_exited(old_target:Node3D):
	if target == old_target:
		target = null

var last_jump_dir := 0
#The boss's weak spot is from behind. This area fires a warning telling the boss
#	to jump out of the way.
func _on_partially_exposed_player_entered(b: Node) -> void:
	#Don't double jump. This may give the player an opening but that's ok
	#	because its funny
	if !is_on_floor():
		return
	
	#Crucial to the puzzle is that the boss only jumps out of the way if the 
	#	*host* is in this zone.
	if !b.multiplayer.is_server(): return
	print("I should jump now. Lol.")
	
	#Now, goal is to maximize distance from `b` without crashing into something.
	velocity -= get_gravity().normalized() * JUMP_VELOCITY
	velocity -= global_transform.basis * get_motion_direction().normalized() * JUMP_HORIZONTAL_VELOCITY
	move_and_slide()
	
	#Determine the sidedness of the jump to choose which animation to play
	# 1 => Right, -1 => Left. Default 0 to Right
	last_jump_dir = signf(get_motion_direction().x)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#Only do this on ground to not interfere with jumps.
	if is_on_floor():
		var input_dir := get_motion_direction()
		var direction := (global_transform.basis * input_dir).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		move_and_slide()
	else:
		move_and_slide()
		var col := get_last_slide_collision()
		if col and !is_on_floor():
			velocity += col.get_normal() * 50.0
	
	if target != null and !is_too_close():
		var look_plane := Plane(get_gravity().normalized(), global_position)
		var new_t := global_transform.looking_at(
			look_plane.project(target.global_position), 
			-get_gravity().normalized(), true
		)
		global_transform = global_transform.interpolate_with(
			new_t, 0.5 * get_rotation_proportion()
		)

func get_motion_direction() -> Vector3:
	if !(target is Node3D) or get_target_distance() < MIN_TARGET_DISTANCE:
		return Vector3.ZERO
	var desired_motion := to_local(target.global_position)
	
	desired_motion -= desired_motion.project(get_gravity())
	return desired_motion

func get_target_distance() -> float:
	if target == null: return INF
	return target.global_position.distance_to(global_position)

func is_too_close():
	return get_target_distance() < MIN_TARGET_DISTANCE

func get_rotation_proportion():
	var x := get_target_distance()
	if !is_on_floor():
		x += AERIAL_ROTATION_BOOST
	var y := (x - MIN_TARGET_DISTANCE) / \
		(MIN_FAST_ROTATE_DISTANCE - MIN_TARGET_DISTANCE)
	
	return clampf(y, 0.0, 1.0)
