extends Timer

func _init():
	print("Initializing timer")
	paused = true

func _on_auto_tick_toggle_toggled(toggled_on):
	print("setting timer to paused = ", !toggled_on)
	paused = !toggled_on


func _on_timeout():
	print("Timer timed out")
