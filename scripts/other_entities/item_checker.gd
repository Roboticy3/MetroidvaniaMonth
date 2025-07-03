extends Node

@export var requirements:PackedInt32Array = [0,0,0,0,0,0]

signal success()
signal fail()

func check():
	for i in requirements.size():
		#bitwise r implies c. If any are false, the requirements are not met
		var r := requirements[i]
		var c := ClientState.save.get_flags(i)
		var ok := ((~r) | c) == -1
		print("checking flag ", i, " with value ", r, " against ", c, " ok? ", ok)
		if !ok:
			fail.emit()
			return
	success.emit()
