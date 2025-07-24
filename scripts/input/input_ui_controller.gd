extends Node

@export var input_ui:PackedScene

func _ready():
	_create_action_list()

func _create_action_list():
	InputMap.load_from_project_settings()
	apply_input_config()
	for item in get_children():
		item.queue_free()
	
	for action in InputMap.get_actions():
		if action.contains("ui"):
			continue
		
		#Initialize the setting for this control
		var button := input_ui.instantiate()
		if !(button is InputSetting): return
		
		button.set("action", action)
		
		var events := InputMap.action_get_events(action)
		if !events.is_empty():
			button.set("inputs", events)
		
		add_child(button)
		
		#Take signals from the setting to set the control through this 
		#	controller
		button.connect("pressed", start_rebind.bind(action, button))

#action being rebound
var rebinding:StringName
#button that was pressed to rebind the action
var rebinding_button:InputSetting
func start_rebind(action:StringName, button:Node):
	if is_instance_valid(rebinding_button):
		end_rebind(rebinding_button)
	
	button.emit_signal("set_input_label", "Listening for input")
	rebinding = action
	rebinding_button = button

func end_rebind(button:InputSetting):
	button.inputs = button.inputs
	rebinding = &""
	rebinding_button = null

func _input(event:InputEvent) -> void:
	if rebinding == &"" or !event.is_pressed(): return

	if rebinding_button.is_keyboard_event(event):
		var key := rebinding_button.get_keyboard_event()
		#print("found existing keybind ", key, " for ", rebinding)
		if InputMap.action_has_event(rebinding, key):
			#print("erasing ", key) 
			InputMap.action_erase_event(rebinding, key)
		#print("binding ", event, " to ", rebinding)
		InputMap.action_add_event(rebinding, event)
		rebinding_button.set_keyboard_event(event)
		#print("inputs synced? ", InputMap.action_get_events(rebinding), rebinding_button.inputs)
		end_rebind(rebinding_button)
		changed = true
	
	elif rebinding_button.is_controller_event(event):
		var joy := rebinding_button.get_controller_event()
		#print("found existing keybind ", key, " for ", rebinding)
		if InputMap.action_has_event(rebinding, joy):
			#print("erasing ", key) 
			InputMap.action_erase_event(rebinding, joy)
		#print("binding ", event, " to ", rebinding)
		InputMap.action_add_event(rebinding, event)
		rebinding_button.set_controller_event(event)
		#print("inputs synced? ", InputMap.action_get_events(rebinding), rebinding_button.inputs)
		end_rebind(rebinding_button)
		changed = true

var mouse_sens := 0.002
func set_mouse_sens(to:float) -> void:
	mouse_sens = to

var controller_sens := 3.0
func set_controller_sens(to:float) -> void:
	controller_sens = to

func create_input_config() -> InputConfig:
	var config = InputConfig.new()
	for c in get_children():
		if c is InputSetting:
			var action := InputActionConfig.new()
			action.name = c.action
			action.events = c.inputs
			config.mapping.append(action)
	config.mouse_sens = mouse_sens
	config.controller_sens = controller_sens
	return config

@export var save_path := "user://input_config.tres"
var changed = false

func save():
	if !changed: return
	var error := ResourceSaver.save(create_input_config(), save_path)
	changed = error != OK

func apply_input_config():
	var result = ResourceLoader.load(save_path)
	if !(result is InputConfig): return
	
	var config := result as InputConfig
	for m in config.mapping:
		InputMap.action_erase_events(m.name)
		for e in m.events:
			InputMap.action_add_event(m.name, e)
	
