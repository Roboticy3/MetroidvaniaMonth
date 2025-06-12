extends Node

#Update the volume of the master bus and save state
func _on_value_changed(to:float) -> void:
	print("setting volume to ", to / 100.0)
	AudioServer.set_bus_volume_linear(0, to / 100.0)
