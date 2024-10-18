extends Node2D

@export var rise_speed: float = 50
@export var duration: float = 0.5

var damage

@onready var label = $Label
@onready var timer = $Timer


func _ready():
	label.text = str(self.damage)
	timer.paused = false
	timer.start(duration)


func _process(delta: float):
	position.y -= rise_speed * delta
	modulate.a -= delta / duration


func _on_timer_timeout():
	print("Hit splat timer timed out")
	queue_free()
