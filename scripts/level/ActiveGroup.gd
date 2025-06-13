## Assign nodes to the same group such that only one will be visible at a given
## time.
extends Resource
class_name ActiveGroup

@export var active_key := "active"
@export_storage var users:Array[Node] = []

signal active_changed(to:Node)

func grab(with:Node):
	with.set(active_key, true)
	active_changed.emit(with)
	
	var found_with := false
	for u in users:
		if !is_instance_valid(u):
			printerr("Group ", self, " could not validate instance ", u)
			continue
		if u == with: 
			found_with = true
			continue
		u.set(active_key, false)
	
	if not found_with:
		add_user(with)

func get_active() -> Node:
	for u in users:
		if u.get(active_key):
			return u
	return null

func add_user(new_u:Node) -> bool:
	for u in users:
		if u == new_u: return false
	users.append(new_u)
	new_u.tree_exiting.connect(remove_user.bind(new_u))
	return true

func remove_user(old_u:Node) -> bool:
	var i = 0
	for u in users:
		if u == old_u:
			users.remove_at(i)
			return true
		i += 1
	return false
