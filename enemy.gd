extends BaseCharacter

signal enemy_destroyed()

var hit_splat_scene = preload("res://hit_splat.tscn")
const ticks_between_wanders = 10
var wander_counter = 0

@onready var progress_bar = $EnemyUIElements/ProgressBar

@export var health: int = 10
@export var max_health: int = 10

func _ready():
	super._ready()
	progress_bar.value = health
	progress_bar.max_value = max_health
	self.tile_location = Vector2i(1, 0)


func handle_incoming_attack(damage: int, attackerId: String):
	print("Enemy received attack from attacker ", attackerId, ". Damage: ", damage)
	_handle_incoming_damage(damage)
	_display_damage(damage)
	set_attack_target(attackerId)
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
	process_game_tick()

func _process_wandering_tick():
	wander_counter = ((wander_counter + 1) % ticks_between_wanders)
	print("[Enemy] wander counter: ", wander_counter)
	if (wander_counter == 0):
		var next_target_position = Vector2i(
			randi_range(0, 10),
			randi_range(0, 10)
		)
		print("[Enemy] Setting new target position to ", next_target_position)
		set_target_position(next_target_position)


func _on_character_controller_request_move(new_position):
	set_tile_location(new_position)
