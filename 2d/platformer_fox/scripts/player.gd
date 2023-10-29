extends CharacterBody2D


const SPEED := 250.0
const JUMP_VELOCITY := -400.0

var _gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var _health := 10

@onready var _anim := get_node("AnimatedSprite2D") as AnimatedSprite2D


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += _gravity * delta
		if velocity.y > 0:
			_anim.play("fall")
	elif Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
		_anim.play("jump")

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		_anim.flip_h = true if direction < 0 else false
		if velocity.y == 0:
			_anim.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			_anim.play("idle")

	move_and_slide()
