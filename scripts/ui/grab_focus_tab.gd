extends TabContainer

@export var loop_selection = true
var focused = false

func _ready():
	visibility_changed.connect(grab_focus)
	focus_mode = Control.FOCUS_ALL
	get_viewport().gui_focus_changed.connect(_on_focus_changed)
	
	_on_focus_changed(get_viewport().gui_get_focus_owner())

func _on_focus_changed(node):
	if node == self:
		focused = true
		add_theme_color_override("font_selected_color", Color.CYAN)
	else:
		if focused:
			focused = false
			remove_theme_color_override("font_selected_color")

func _unhandled_input(event):
	if focused:
		var tab = current_tab
		if event.is_action_pressed("ui_left"):
			tab -= 1
		elif event.is_action_pressed("ui_right"):
			tab += 1
		
		if loop_selection:
			current_tab = (get_child_count() + tab) % get_child_count()
		else:
			current_tab = clamp(tab, 0, get_child_count())
