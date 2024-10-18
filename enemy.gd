extends CharacterBody2D

signal enemy_destroyed()
signal character_moved(new_tile_location: Vector2i)

var hit_splat_scene = preload("res://hit_splat.tscn")
var tile_location = Vector2i(1, 0)
var tile_size = 16
const ticks_between_wanders = 10
var wander_counter = 0

@export var health = 10
@export var max_health = 10

func _ready():
	$EnemyUIElements/ProgressBar.value = health
	$EnemyUIElements/ProgressBar.max_value = max_health


func handle_incoming_attack(damage: int):
	print("Enemy received attack. Damage: ", damage)
	_handle_incoming_damage(damage)
	_display_damage(damage)
	if (self.health <= 0):
		_handle_destroyed()


func _handle_destroyed():
		print("Enemy is now dead!")
		enemy_destroyed.emit()
		queue_free()


func _handle_incoming_damage(damage: int):
	self.health -= damage


func _display_damage(damage: int):
	var hit_splat = hit_splat_scene.instantiate()
	hit_splat.damage = 2
	hit_splat.position = self.position + Vector2(-28, -25)
	$EnemyUIElements.add_child(hit_splat)
	$EnemyUIElements/ProgressBar.value = self.health
	$EnemyAudioStreamPlayer.play()


func _on_game_tick():
	_process_wandering_tick()
	$CharacterController.process_game_tick()

func _process_wandering_tick():
	wander_counter = ((wander_counter + 1) % ticks_between_wanders)
	print("[Enemy] wander counter: ", wander_counter)
	if (wander_counter == 0):
		var next_target_position = Vector2i(
			randi_range(0, 10),
			randi_range(0, 10)
		)
		print("[Enemy] Setting new target position to ", next_target_position)
		$CharacterController.set_target_position(next_target_position)


func _set_tile_location(new_tile_location):
	self.tile_location = new_tile_location
	var next_position = Vector2i(
		tile_size * new_tile_location.x + (tile_size / 2),
		tile_size * new_tile_location.y + (tile_size / 2)
	)
	print("[Enemy] Next position: ", next_position)
	self.position = next_position
	character_moved.emit(self.tile_location)

func _on_character_controller_request_move(new_position):
	_set_tile_location(new_position)
