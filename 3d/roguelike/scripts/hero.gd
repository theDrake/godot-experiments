class_name Hero
extends CharacterBody3D


signal gate_opened()
signal died()

const MAX_HEALTH: float = 100.0
const DEFAULT_ATTACK_POWER: float = 20.0
const DEFAULT_SPEED: float = 200.0
const DEFAULT_JUMP_STRENGTH: float = 4.0
const SPRINT_MULTIPLIER: float = 2.0
const MIN_VELOCITY_FOR_WALK_ANIM: float = 2.0
const MIN_VELOCITY_FOR_SPRINT_ANIM: float = 4.0
const ATTACK_ANIMATIONS: Array[String] = [
	"attack-melee-left",
	"attack-melee-right",
]
const INTERACT_ANIMATIONS: Array[String] = [
	"interact-left",
	"interact-right",
]

@export var view: View
var alive: bool = true

var _health: float:
	set(value):
		_health = clampf(value, 0, MAX_HEALTH)
		_health_display.update(_health / MAX_HEALTH)
		if _health <= 0:
			_die()
var _attack_power: float = DEFAULT_ATTACK_POWER
var _speed: float = DEFAULT_SPEED
var _jump_strength: float = DEFAULT_JUMP_STRENGTH
var _move_velocity: Vector3
var _rotation_dir: float
var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _attacking: bool = false

@onready var _anim: AnimationPlayer = $Model/AnimationPlayer
@onready var _health_display: HealthDisplay = $HealthDisplay
@onready var _ray: RayCast3D = $InteractionRay
@onready var _attack_radius: Area3D = $AttackRadius
@onready var _attack_timer: Timer = $AttackTimer
@onready var _fall_timer: Timer = $FallTimer


func _ready() -> void:
	_health = MAX_HEALTH * 0.75 # let player learn chests restore health


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"): # Esc or Ctrl+Q
		get_tree().quit()
	elif not alive:
		return

	# falling, jumping, actions, and animation management
	if not is_on_floor():
		velocity.y -= _gravity * delta
		if velocity.y < 0:
			_anim.play("fall")
			if _fall_timer.is_stopped():
				_fall_timer.start()
	else:
		_fall_timer.stop()
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = _jump_strength
			_anim.play("jump")
		elif Input.is_action_pressed("attack"):
			_attack()
		elif Input.is_action_just_pressed("interact"):
			var collider = _ray.get_collider()
			if collider:
				_anim.play(INTERACT_ANIMATIONS[
						randi() % INTERACT_ANIMATIONS.size()])
				if collider is Gate:
					collider.open()
					gate_opened.emit()
				elif collider is Chest:
					collider.open()
					_health += MAX_HEALTH / 2
			else:
				_anim.play("emote-no")
		elif velocity.length() > MIN_VELOCITY_FOR_SPRINT_ANIM:
			_anim.play("sprint")
		elif velocity.length() > MIN_VELOCITY_FOR_WALK_ANIM:
			_anim.play("walk")
		else:
			var anim: String = _anim.get_current_animation()
			if not anim.begins_with("a") and not anim.begins_with("e") and not \
					anim.begins_with("in"):
				_anim.play("idle")

	# movement
	if Input.is_key_pressed(KEY_SHIFT):
		_speed = DEFAULT_SPEED * SPRINT_MULTIPLIER
	else:
		_speed = DEFAULT_SPEED
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	input = input.rotated(Vector3.UP, view.rotation.y).normalized()
	_move_velocity = input * _speed * delta
	var applied_velocity: Vector3 = velocity.lerp(_move_velocity, delta * 10)
	applied_velocity.y = velocity.y
	velocity = applied_velocity
	move_and_slide()

	# rotation
	if Vector2(velocity.z, velocity.x).length() > 0:
		_rotation_dir = Vector2(velocity.z, velocity.x).angle()
	rotation.y = lerp_angle(rotation.y, _rotation_dir, delta * 10)


func take_damage(amount: float) -> void:
	_health -= amount


func _attack() -> void:
	if not _attacking:
		_attacking = true
		_anim.play(ATTACK_ANIMATIONS[randi() % ATTACK_ANIMATIONS.size()])
		_attack_timer.start()
		for body in _attack_radius.get_overlapping_bodies():
			if body is Enemy:
				body.take_damage(_attack_power)
				body.velocity += (body.position - position).normalized() * \
						_attack_power


func _die() -> void:
	if alive:
		alive = false
		_health = 0
		_anim.play("die")
		died.emit()


func _on_attack_timer_timeout() -> void:
	_attacking = false


func _on_fall_timer_timeout() -> void:
	if not is_on_floor():
		_die()
