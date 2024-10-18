extends CharacterBody2D

class_name BaseCharacter

signal character_moved(new_location: Vector2i)
signal attack(target: String)

var tile_size = 16

var tile_location: Vector2i
var target_tile: Vector2i
var path = []
var _astar = AStarGrid2D.new()

var attack_target: String
var attack_cooldown = 0
@export var ticks_per_attack = 4

func _ready():
	print("[Base Character] Executing _ready!")
	_astar.region = Rect2i(0, 0, 15, 10)
	_astar.update()
	set_target_position(Vector2i(5, 5))


func set_target_position(new_target_position: Vector2i):
	self.target_tile = new_target_position
	path = _astar.get_point_path(tile_location, new_target_position)
	path = path.slice(1, path.size())
	print("[Base Character] path: ", path)


func set_tile_location(new_tile_location: Vector2i):
	self.tile_location = new_tile_location
	var next_position = Vector2i(
		tile_size * new_tile_location.x + (tile_size / 2),
		tile_size * new_tile_location.y + (tile_size / 2)
	)
	self.position = next_position
	print("[Base Character] Next position: ", next_position)
	character_moved.emit(self.tile_location)


func process_game_tick():
	_process_movement_tick()
	_process_attack_tick()

func _process_movement_tick():
	print("[Base Charater] processing movement")
	if path.size() > 0:
		var next_tile = path[0]
		path = path.slice(1, path.size())
		set_tile_location(next_tile)


func _process_attack_tick():
	if not attack_target:
		print("[Base Characer] Character has no target.")
		return
	print("[Base Character] attack_cooldown: ", attack_cooldown)
	attack_cooldown = (attack_cooldown + 1) % ticks_per_attack
	if attack_cooldown == 0:
		print("[Base Character] executing attack!")
		#$AnimatedSprite2D.animation = "attack"
		attack.emit(attack_target)


func set_attack_target(new_attack_target: String):
	self.attack_target = new_attack_target
