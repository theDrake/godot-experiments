extends AnimatableBody2D


const SPEED := 100.0

var _direction := -1

@onready var _anim := get_node("AnimatedSprite2D") as AnimatedSprite2D
@onready var _ray := get_node("RayCast2D") as RayCast2D


func _physics_process(delta: float) -> void:
	if _ray.is_colliding():
		position.x += _direction * SPEED * delta
	else:
		_ray.position.x *= -1
		_direction *= -1
		_anim.flip_h = not _anim.flip_h
