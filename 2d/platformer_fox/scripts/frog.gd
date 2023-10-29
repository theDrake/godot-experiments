extends AnimatableBody2D


const JUMP_SPEED := 300.0
const JUMP_HEIGHT := 100.0

var _jumping := false
var _falling := false

@onready var _anim := get_node("AnimatedSprite2D") as AnimatedSprite2D
@onready var _jump_timer := get_node("Timer") as Timer
@onready var _spawn_y := position.y


func _physics_process(delta: float) -> void:
	if _jumping:
		position.y -= JUMP_SPEED * delta
		if _spawn_y - position.y >= JUMP_HEIGHT:
			_jumping = false
			_falling = true
			_anim.play("fall")
	elif _falling:
		position.y += JUMP_SPEED * delta
		if position.y >= _spawn_y:
			position.y = _spawn_y
			_falling = false
			_anim.play("idle")
			_jump_timer.start()


func _on_timer_timeout() -> void:
	_jumping = true
	_anim.play("jump")
