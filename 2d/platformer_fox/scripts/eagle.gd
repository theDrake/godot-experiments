extends AnimatableBody2D


const SPEED := 200.0

var _direction := -1

@onready var _anim := get_node("AnimatedSprite2D") as AnimatedSprite2D


func _physics_process(delta: float) -> void:
	position.x += _direction * SPEED * delta


func _on_timer_timeout() -> void:
	_direction *= -1
	_anim.flip_h = not _anim.flip_h
