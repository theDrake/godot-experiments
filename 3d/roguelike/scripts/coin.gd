class_name Coin
extends Node3D


var _rise_speed: float = 2.0
var _rotate_speed: float = 20.0

@onready var _timer: Timer = $Timer


func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	position.y += _rise_speed * delta
	rotate_y(_rotate_speed * delta)


func animate() -> void:
	visible = true
	set_process(true)
	_timer.start()


func _on_timer_timeout() -> void:
	queue_free()
