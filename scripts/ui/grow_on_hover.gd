extends Control

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

@onready var initial_scale := scale
@export var time := 0.25
@export var hover_scale_multiplier := 2.0

func _on_mouse_entered():
	var scale_tween := create_tween()
	scale_tween.tween_property(self, "scale", initial_scale * hover_scale_multiplier, time)

func _on_mouse_exited():
	var scale_tween := create_tween()
	scale_tween.tween_property(self, "scale", initial_scale, time)
