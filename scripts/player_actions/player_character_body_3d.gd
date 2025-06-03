extends CharacterBody3D

var fuel:Range
var health:Range

func _ready():
	fuel = get_meter("Fuel")
	health = get_meter("Health")
	
	#Apply multiplayer authority to this player
	print("checking body ", self, " with authority ", get_multiplayer_authority(), " against ", multiplayer.get_unique_id())
	if !is_multiplayer_authority():
		set_process_unhandled_input(false)
		set_physics_process(false)
		return
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func get_meter(group:StringName) -> Range:
	for f in get_tree().get_nodes_in_group(group):
		if f is Range and f.is_multiplayer_authority():
			print("found ", group, " member ", f)
			return f
	return null

const LOOK_SENS := 0.005
var look_rotation := Vector2.ZERO
signal look(scaled_relative:Vector2)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_rotation.x += -event.relative.y * LOOK_SENS
		look_rotation.y += -event.relative.x * LOOK_SENS
		rotation.y = look_rotation.y
		look.emit(look_rotation)


const GROUND_SPEED := 20.0
const GROUND_ACCEL := 200.0
const JUMP_ACCEL := 50.0
const FALL_ACCEL := 30.0

const JUMP_SPEED := 10.0
const FALL_SPEED := 30.0
#const JUMP_STOP := -10.0
const JUMP_START := 10.0

const FALL_SUPER_TIME := 2.0
const FALL_SUPER_SPEED := 50.0

var time_falling := 0.0
var time_hovering := 0.0

#Keep a network synchronized copy of velocity for controlling animations
@export var velocity_sync := Vector3.ZERO
func _physics_process(delta: float) -> void:
	
	update_time_falling(delta)
	update_time_hovering(delta)
	
	boost(delta)
	fly_and_fall(delta)
	
	update_horizontal_velocity(delta)

	move_and_slide()
	velocity_sync = velocity

func update_time_falling(delta:float) -> void:
	#If falling for long enough, upgrade to a super fall
	if is_falling():
		time_falling += delta
	else:
		time_falling = 0.0
	
func update_time_hovering(delta:float) -> void:
	#Count time hovering
	if is_on_floor():
		if fuel: fuel.fill(delta)
		time_hovering = 0.0
	elif is_flying():
		if fuel: fuel.drain(delta)
		time_hovering += delta

func boost(delta:float) -> void:
	#Reward players that have been hovering for a while with a boost!
	#Translates to "just stopped flying and was moving up relative to gravity and is not on the floor"
	if Input.is_action_just_released("Jump") and (velocity.dot(get_gravity()) < 0.0 and (not is_on_floor())):
		velocity -= get_gravity() * delta * clampf(3.0 * time_hovering, 0.0, 10.0)
	#Translates to "just started flying and is on the ground"
	elif Input.is_action_just_pressed("Jump") and (is_on_floor()):
		velocity -= get_gravity() * delta * JUMP_START

func fly_and_fall(delta:float) -> void:
	# Handle jump.
	#More of a jetpack now >:)
	if is_flying():
		velocity -= signf(JUMP_SPEED - velocity.y) * get_gravity() * delta
	elif is_falling():
		if time_falling >= FALL_SUPER_TIME:
			velocity += signf(FALL_SUPER_SPEED - velocity.y) * get_gravity() * delta
		else:
			velocity += signf(FALL_SPEED + velocity.y) * get_gravity() * delta

func update_horizontal_velocity(delta:float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := get_horizontal_movement_axis()
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var current_vertical_velocity := velocity.y
	var accel := get_horizontal_acceleration()
	velocity = velocity.move_toward(direction * GROUND_SPEED, accel * delta)
	velocity.y = current_vertical_velocity

func is_flying():
	if !is_multiplayer_authority():
		return false
	
	return !fuel.is_empty() and Input.is_action_pressed("Jump")

func is_falling():
	return (not is_on_floor()) and (not is_flying())

func get_mode():
	if is_on_floor():
		return 0
	elif is_flying():
		return 1
	elif is_falling():
		return 2
	
	return -1

func get_horizontal_acceleration() -> float:
	match get_mode():
		0: return GROUND_ACCEL
		1: return JUMP_ACCEL
		2: return FALL_ACCEL
	
	return GROUND_ACCEL

func is_stopped() -> bool:
	return velocity_sync.is_zero_approx()

func get_horizontal_movement_axis() -> Vector2:
	if !is_multiplayer_authority():
		return Vector2.ZERO
	return Input.get_vector("Left", "Right", "Up", "Down")

func _on_shoot(_p, _id):
	pass

@rpc("any_peer", "call_local", "reliable")
func apply_central_impulse_rpc(impulse:Vector3):
	velocity += impulse
	#health will exist only on individual clients,
	#	but, since the value is synced, that's the only place where we need to
	#	change it.
	if health and is_multiplayer_authority():
		health.drain(1)
			
