extends BaseCharacter

signal show_target_position(target_position)

@export var controlled = false

var target_position = position;


var _tilemap

func _ready():
	super._ready()
	_tilemap = get_parent().get_node("TileMap")

func _on_tile_map_tile_clicked(new_target_position):
	set_target_position(new_target_position)
	clear_attack_target()

func _on_set_attack_target(attack_target, attack_target_position):
	print("Attacking the chaos knight!")
	set_attack_target("Chaos knight")
	_move_to_attack_target(attack_target_position)

func _on_game_tick():
	print("[Player] Player is reacting to game tick")
	process_game_tick()


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation != "idle":
		print("Current animation: ", $AnimatedSprite2D.animation)
		$AnimatedSprite2D.play("idle")
		print("Current animation: ", $AnimatedSprite2D.animation)


func _move_to_attack_target(attack_target_position):
	var path_to_attack_target = _astar.get_point_path(tile_location, attack_target_position)
	print("Path to attack target: ", path_to_attack_target)
	if path_to_attack_target.size() == 0:
		return
	var target_position = path_to_attack_target[0]
	if path_to_attack_target.size() > 1:
		target_position = path_to_attack_target[path_to_attack_target.size() - 2]
	set_target_position(target_position)


func set_target_position(new_target_position):
	super.set_target_position(new_target_position)
	show_target_position.emit(new_target_position)


func on_enemy_moved(new_tile_location):
	if get_attack_target():
		_move_to_attack_target(new_tile_location)


func handle_incoming_attack(damage: int, attackerId: String):
	print("[Player] character is being attacked for ", damage, " damage by ", attackerId)
	
