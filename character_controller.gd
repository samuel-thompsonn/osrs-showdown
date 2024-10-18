extends Node2D

@export var ticks_per_attack = 4

signal attack
signal request_move(target_position: Vector2i)

var path = []
var attack_target
var attack_cooldown
var current_tile = Vector2(0, 0)
var target_positon = Vector2i(5, 4)
const tile_size = 16

var _astar = AStarGrid2D.new()

func _ready():
	_astar.region = Rect2i(0, 0, 15, 10)
	_astar.update()
	set_target_position(target_positon)

func process_game_tick():
	_process_movement_tick()
	_process_attack_tick()


func _process_movement_tick():
	print("CharacterController is processing movement")
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


func _set_position(new_position):
	print("Character controller is setting position to ", new_position)
	current_tile = new_position
	request_move.emit(new_position)


func set_target_position(new_target_position: Vector2i):
	self.target_positon = new_target_position
	path = _astar.get_point_path(current_tile, target_positon)
	path = path.slice(1, path.size())
	print("[CharacterController] path: ", path)
