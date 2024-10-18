extends Node2D

var world_scene = preload("res://world.tscn")
@onready var current_world = $World

func _on_game_tick_button_pressed():
	current_world._on_game_tick()

func _on_game_tick_timer_timeout():
	current_world._on_game_tick()

func _on_play_again_button_pressed():
	current_world.queue_free()
	var new_world_scene = world_scene.instantiate()
	add_child(new_world_scene)
	new_world_scene.connect("battle_complete", $UserInterfaceLayer._on_battle_complete)
	new_world_scene.show_world_actions.connect($UserInterfaceLayer._on_show_actions)
	current_world = new_world_scene
	$UserInterfaceLayer.reset()

