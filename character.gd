extends CharacterBody2D

signal attack(target)

@export var controlled = false
@export var tile_size = 16

var _astar = AStarGrid2D.new()
var current_tile = Vector2(0, 0)

var target_position = position;
var path = []

var attack_target
var ticks_per_attack = 4
var attack_cooldown = 0

var _tilemap

func _ready():
	_astar.region = Rect2i(0, 0, 15, 10)
	_astar.update()
	_tilemap = get_parent().get_node("TileMap")

func _on_tile_map_tile_clicked(new_target_position):
	_set_target_position(new_target_position)
	attack_target = null

func _set_target_position(new_target_position):
	print("new target position: ", new_target_position)
	_tilemap.set_cell(2, target_position, -1)
	_tilemap.set_cell(2, new_target_position, 0, Vector2(7, 9))
	target_position = new_target_position
	path = _astar.get_point_path(current_tile, new_target_position)
	path = path.slice(1, path.size())
	print("path: ", path)


func _on_set_attack_target(attack_target, attack_target_position):
	print("Attacking the chaos knight!")
	self.attack_target = 1
	var path_to_attack_target = _astar.get_point_path(current_tile, attack_target_position)
	print("Path to attack target: ", path_to_attack_target)
	if path_to_attack_target.size() == 0:
		return
	elif path_to_attack_target.size() == 1:
		_set_target_position(path_to_attack_target[0])
	else:
		_set_target_position(path_to_attack_target[path_to_attack_target.size() - 2])


func _set_position(target_position):
	current_tile = target_position
	print("[Character] target tile position: ", target_position)
	var next_position = Vector2i(
		tile_size * target_position.x + (tile_size / 2),
		tile_size * target_position.y + (tile_size / 2)
	)
	print("[Character] Next position: ", next_position)
	position = next_position

func _on_game_tick():
	print("character is reacting to game tick")
	_process_movement_tick()
	_process_attack_tick()


func _process_movement_tick():
	if path.size() > 0:
		var next_tile = path[0]
		path = path.slice(1, path.size())
		_set_position(next_tile)


func _process_attack_tick():
	if attack_target == null:
		print("Character has no target.")
		return
	print("attack_cooldown: ", attack_cooldown)
	attack_cooldown = (attack_cooldown + 1) % ticks_per_attack
	if attack_cooldown == 0:
		# TODO: Check whether we are in a position to attack
		print("executing attack!")
		$AnimatedSprite2D.animation = "attack"
		attack.emit("Chaos knight")


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation != "idle":
		print("Current animation: ", $AnimatedSprite2D.animation)
		$AnimatedSprite2D.play("idle")
		print("Current animation: ", $AnimatedSprite2D.animation)
