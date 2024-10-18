extends CanvasLayer

var current_action_menu
var action_menu_scene = preload("res://action_menu.tscn")

func _ready():
	$GameTickTimer._on_auto_tick_toggle_toggled($AutoTickToggle.button_pressed)


func _on_show_actions(actions: Array[ActionMenuItem]):
	print("Show actions signal requested")
	_create_action_menu(actions)

func _create_action_menu(actions: Array[ActionMenuItem]):
	if current_action_menu:
		current_action_menu.queue_free()
	current_action_menu = action_menu_scene.instantiate()
	current_action_menu.initialize_menu(actions, get_viewport().get_mouse_position())
	print("creating action menu in UI layer")
	add_child(current_action_menu)


func _on_battle_complete():
	$Message.text = "You win!"
	$Message.show()
	$PlayAgainButton.show()
	$WinAudioPlayer.play()


func reset():
	$PlayAgainButton.hide()
	$Message.hide()
