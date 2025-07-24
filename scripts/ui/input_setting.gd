extends Button

@export var action:StringName : 
	set(new_action):
		action = new_action
		set_action_label.emit(new_action)
@export var inputs:Array[InputEvent] :
	set(new_inputs):
		inputs = new_inputs
		var key := get_keyboard_event()
		if key:
			set_input_label.emit(get_event_string(key))
		#stop the user from auto-clicking the button after setting it
		if get_tree():
			disabled = true
			get_tree().create_timer(0.25).timeout.connect(func ():
				disabled = false
			)
		
signal set_action_label(to:String)
signal set_input_label(to:String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	action = action
	inputs = inputs

func get_event_string(e:InputEvent) -> String:
	if e is InputEventKey:
		return e.as_text().trim_suffix(" (Physical)")
	if e is InputEventMouseButton:
		return e.as_text()
	return ""

#Check if input is suitable for binding via a keyboard
func is_keyboard_event(e:InputEvent) -> bool:
	return e is InputEventMouseButton or e is InputEventKey

func get_keyboard_event() -> InputEvent:
	for e in inputs:
		if is_keyboard_event(e):
			return e
	return null

func set_keyboard_event(new_e:InputEvent) -> bool:
	if !is_keyboard_event(new_e):
		return false
	for i in inputs.size():
		var e := inputs[i]
		if is_keyboard_event(e):
			inputs[i] = new_e
	inputs.append(new_e)
	inputs = inputs
	return true

func is_controller_event(e:InputEvent) -> bool:
	return e is InputEventJoypadButton or e is InputEventJoypadMotion

func get_controller_event() -> InputEvent:
	for e in inputs:
		if is_controller_event(e):
			return e
	return null

func set_controller_event(new_e:InputEvent):
	if !is_keyboard_event(new_e):
		return false
	for i in inputs.size():
		var e := inputs[i]
		if is_controller_event(e):
			inputs[i] = new_e
	inputs.append(new_e)
	inputs = inputs
	return true
