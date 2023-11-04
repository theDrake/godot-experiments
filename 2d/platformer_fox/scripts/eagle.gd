extends AnimatableBody2D
## Eagle handler for the 'Fox' platformer game.
##
## Eagles fly back and forth in the air. They hurt the player from below, but
## are harmless from above, so the player can "ride" them.


const SPEED := 200.0
const ATTACK_POWER := 2

var _direction := -1

@onready var _anim := $AnimatedSprite2D as AnimatedSprite2D


func _physics_process(delta: float) -> void:
	position.x += _direction * SPEED * delta


func _on_timer_timeout() -> void:
	_direction *= -1
	_anim.flip_h = not _anim.flip_h


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.name.begins_with("Play"):
		body.reduce_health(ATTACK_POWER)
