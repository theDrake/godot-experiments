extends CharacterBody2D
## Player handler for the 'Fox' platformer game.
##
## Handles user input for left-right movement and jumping.


const STARTING_LIVES := 3
const STARTING_HEALTH := 10
const POINTS_PER_EXTRA_LIFE := 100
const SPEED := 250.0
const JUMP_VELOCITY := -400.0
const MAX_Y := 720

var _gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var _spawn_point: Vector2
var _lives: int
var _health: int
var _points: int
var _hurt := false
var _dead := false

@onready var _anim := $AnimatedSprite2D as AnimatedSprite2D
@onready var _points_label := $CanvasLayer/PointsLabel as RichTextLabel
@onready var _lives_label := $CanvasLayer/LivesLabel as RichTextLabel
@onready var _health_label := $CanvasLayer/HealthLabel as RichTextLabel


func _ready() -> void:
	_spawn_point = position
	_set_lives(STARTING_LIVES)
	_set_health(STARTING_HEALTH)
	_set_points(0)


func _physics_process(delta: float) -> void:
	if _dead:
		return

	if not is_on_floor():
		velocity.y += _gravity * delta
		if position.y > MAX_Y:
			_set_health(0)
			return
		if velocity.y > 0 and not _hurt:
			_anim.play("fall")
	elif Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
		if not _hurt:
			_anim.play("jump")

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		_anim.flip_h = true if direction < 0 else false
		if velocity.y == 0 and not _hurt:
			_anim.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0 and not _hurt:
			_anim.play("idle")

	move_and_slide()


func alive() -> bool:
	return not _dead


func add_points(amount: int) -> void:
	if not _dead:
		var new_points := _points
		for i in amount:
			new_points += 1
			if new_points % POINTS_PER_EXTRA_LIFE == 0:
				_set_lives(_lives + 1)
		_set_points(new_points)


func add_health(amount: int) -> void:
	_set_health(_health + amount)


func reduce_health(amount: int) -> void:
	if not _hurt:
		_hurt = true
		_set_health(_health - amount)
		if not _dead:
			_anim.play("hurt")
			await _anim.animation_finished
			_hurt = false


func _set_health(n: int) -> void:
	if not _dead:
		_health = max(n, 0)
		_health_label.text = "HP: " + str(_health)
		if _health <= 0:
			_die()


func _set_points(n: int) -> void:
	if not _dead:
		_points = n
		_points_label.text = "Points: " + str(_points)


func _set_lives(n: int) -> void:
	if not _dead:
		_lives = n
		_lives_label.text = "Lives: " + str(_lives)


func _die() -> void:
	if not _dead:
		_set_lives(_lives - 1)
		_dead = true
		velocity = Vector2.ZERO
		_anim.play("die")
		await _anim.animation_finished
		_anim.visible = false
		if _lives > 0:
			await get_tree().create_timer(1.0).timeout
			_anim.play("idle")
			position = _spawn_point
			_anim.visible = true
			_hurt = false
			_dead = false
			_set_health(STARTING_HEALTH)
		else:
			await get_tree().create_timer(2.0).timeout
			get_tree().reload_current_scene()
