extends Node2D

signal game_tick
signal show_world_actions(actions: Array[ActionMenuItem])
signal battle_complete()

var action_menu_scene = preload("res://action_menu.tscn")
var current_action_menu
var terminated = false

func _on_game_tick():
	if (not terminated):
		print("world: game ticked")
		game_tick.emit()
	else:
		print("world: game tick attempted, but world is terminated")

func _on_tile_options_requested(target_position):
	print("creating action menu")
	var actions: Array[ActionMenuItem] = []
	actions.append(_new_action_menu_item(
		"Walk here",
		ActionMenuItem.MOVE,
		_on_move_requested.bind(target_position))
	)
	for enemy in get_enemies(target_position):
		actions.append(_new_action_menu_item("Attack " + enemy, ActionMenuItem.ATTACK, _on_attack_requested.bind(target_position)))
	actions.append(_new_action_menu_item("Cancel", "CANCEL"))
	show_world_actions.emit(actions)

func _new_action_menu_item(label: String, type: String, callback: Callable = func(): pass):
	var action = ActionMenuItem.new(label, type)
	action.action_requested.connect(callback)
	return action


func _on_move_requested(target_tile: Vector2i):
	print("World is reacting to move to ", target_tile)
	$Character._set_target_position(target_tile)

func _on_attack_requested(attack_tile_position):
	print("Attack requested to world")
	$Character._on_set_attack_target("Chaos knight", attack_tile_position)

func get_enemies(target_tile_position):
	print("Target tile position: ", target_tile_position)
	var enemy_position =  $TileMap.local_to_map($EnemyInstance.position)
	print("Enemy position: ", enemy_position)
	if target_tile_position == enemy_position:
		return ["Chaos knight"]
	return []


func _on_character_attack(target):
	# For now, assume the target is the one EnemyInstance
	# TODO: Check if the player is in a position to attack or not
	if ($EnemyInstance):
		if (not _tiles_adjacent($EnemyInstance.tile_location, $Character.current_tile)):
			print("Character attempted to attack Chaos Knight but was too far away. Enemy tile: ", $EnemyInstance.tile_location, " Character tile: ", $Character.current_tile)
			return
		$EnemyInstance.handle_incoming_attack(2)


func _tiles_adjacent(first_tile: Vector2, second_tile: Vector2):
	return (first_tile.distance_to(second_tile)) <= sqrt(2)
	

func _on_enemy_destroyed():
	battle_complete.emit()
	self.terminated = true
