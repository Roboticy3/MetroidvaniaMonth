extends Node

@export var input_config_entry:PackedScene

func _ready():
	_create_action_list()

func _create_action_list():
	InputMap.load_from_project_settings()
	for item in get_children():
		item.queue_free()
	
	for action in InputMap.get_actions():
		if action.contains("ui"):
			continue
		
		#Initialize the setting for this control
		var button := input_config_entry.instantiate()
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
var rebinding_button:Node
func start_rebind(action:StringName, button:Node):
	if is_instance_valid(rebinding_button):
		end_rebind(rebinding_button)
	
	button.emit_signal("set_input_label", "Listening for input")
	rebinding = action
	rebinding_button = button

func end_rebind(button:Node):
	button.inputs = button.inputs
	rebinding = &""
	rebinding_button = null

func _input(event:InputEvent) -> void:
	if rebinding == &"" or !event.is_pressed(): return
	
	if rebinding_button.is_keyboard_event(event):
		rebinding_button.set_keyboard_event(event)
		end_rebind(rebinding_button)
	elif rebinding_button.is_controller_event(event):
		rebinding_button.set_controller_event(event)
		end_rebind(rebinding_button)
