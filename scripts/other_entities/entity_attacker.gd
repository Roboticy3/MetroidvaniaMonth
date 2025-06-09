## Make a child of a player detector. On fire, damages all players inside by the
## specified amount and propels them along the specified vector.

extends Area3D

@export var force := Vector3.ZERO

func _ready():
	body_entered.connect(_on_body_entered)

signal attacked(target:Node)
func _on_body_entered(b:Node):
	if b.is_in_group("Entity"):
		var rot := Basis.from_euler(global_rotation, rotation_order)
		#Auto-applies damage on players
		print("pushing ", b, " on ", rot * force)
		b.apply_central_impulse_rpc.rpc(rot * force)
		attacked.emit(b)
	else: 
		print("not pushing ", b)
