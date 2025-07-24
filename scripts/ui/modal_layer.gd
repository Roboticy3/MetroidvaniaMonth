extends CanvasLayer

@export var control_mouse_mode := true

func _ready():
	if control_mouse_mode:
		update_mouse_mode.call_deferred()
		visibility_changed.connect(update_mouse_mode, CONNECT_DEFERRED)

# Called when the node enters the scene tree for the first time.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle()

signal hidden
signal shown
func toggle():
	visible = !visible
	if visible:
		shown.emit()
	else:
		hidden.emit()

func update_mouse_mode():
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
