extends AnimatableBody2D
## Eagle handler for the 'Fox' platformer game.
##
## Eagles fly back and forth in the air. They hurt the player from below, but
## are harmless from above, so the player can "ride" them.


const SPEED := 150.0
const ATTACK_POWER := 2

@export var _flight_distance := 500.0
var _spawn_position: Vector2
var _target_y: float
var _direction := -1
var _diving := false
var _rising := false

@onready var _anim := $AnimatedSprite2D as AnimatedSprite2D
@onready var _ray := $RayCast2D as RayCast2D


func _ready() -> void:
	_spawn_position = position


func _physics_process(delta: float) -> void:
	if _diving:
		position.y += SPEED * delta
		if position.y >= _target_y:
			_diving = false
			_rising = true
	elif _rising:
		position.y -= SPEED * delta
		if position.y <= _spawn_position.y:
			_rising = false
	else:
		position.x += _direction * SPEED * delta
		if (_direction > 0 and position.x > _spawn_position.x) or (_direction <
				0 and position.x < _spawn_position.x - _flight_distance):
			_direction *= -1
			_anim.flip_h = not _anim.flip_h
		var target := _ray.get_collider()
		if target and target.has_method("reduce_health") and target.alive():
			_target_y = target.position.y
			_diving = true


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.name.begins_with("Play"):
		body.reduce_health(ATTACK_POWER)
