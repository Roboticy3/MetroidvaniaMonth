extends Node

func _on_player_entered(b:Node) -> void:
	b.get_parent().check_health(-1.0)
