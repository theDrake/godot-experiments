class_name Enemy
extends CharacterBody3D


const MAX_HEALTH: float = 50.0
const MAX_DISTANCE_FROM_HERO: float = 15.0
const DEFAULT_ATTACK_POWER: float = 10.0
const DEFAULT_SPEED: float = 120.0
const DEFAULT_JUMP_STRENGTH: float = 3.0
const ATTACK_ANIMATIONS: Array[String] = [
	"attack-melee-left",
	"attack-melee-right",
]

var alive: bool = true

var _health: float = MAX_HEALTH:
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
var _target: Hero
var _attacking: bool = false

@onready var _anim: AnimationPlayer = $Model/AnimationPlayer
@onready var _health_display: HealthDisplay = $HealthDisplay
@onready var _ray_down: RayCast3D = $RayDown
@onready var _ray_forward: RayCast3D = $RayForward
@onready var _attack_timer: Timer = $AttackTimer
@onready var _fall_timer: Timer = $FallTimer
@onready var _death_timer: Timer = $DeathTimer


func _ready() -> void:
	_health_display.visible = false
	rotate_y(PI * randf() * 2)


func _physics_process(delta: float) -> void:
	if not alive:
		return
	elif _target and (_target.position - position).length() > \
			MAX_DISTANCE_FROM_HERO:
		queue_free()

	# falling, jumping, and animation management
	if not is_on_floor():
		velocity.y -= _gravity * delta
		if velocity.y < 0:
			_anim.play("fall")
			if _fall_timer.is_stopped():
				_fall_timer.start()
	else:
		_fall_timer.stop()
		if is_on_floor() and _ray_down.get_collider() == null:
			velocity.y = _jump_strength
			_anim.play("jump")
		elif not _attacking:
			if velocity.length() > 1.0:
				_anim.play("walk")
			else:
				_anim.play("idle")

	# combat and movement
	_move_velocity = Vector3.ZERO
	if _target and _target.alive and not _attacking:
		if _ray_forward.get_collider() == _target:
			_attack(_target)
		else:
			_move_velocity = (_target.position - position).normalized()
			_move_velocity.y = 0
			_move_velocity *= _speed * delta
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


func _attack(hero: Hero) -> void:
	_attacking = true
	_anim.play(ATTACK_ANIMATIONS[randi() % ATTACK_ANIMATIONS.size()])
	hero.take_damage(_attack_power)
	_attack_timer.start()


func _die() -> void:
	if alive:
		alive = false
		_health = 0
		_anim.play("die")
		$CollisionShape3D.queue_free()
		_death_timer.start()


func _on_body_sensed(body: Node3D) -> void:
	if not _target and body is Hero:
		_target = body
		_health_display.visible = true


func _on_attack_timer_timeout() -> void:
	_attacking = false


func _on_fall_timer_timeout() -> void:
	_die()


func _on_death_timer_timeout() -> void:
	_health_display.visible = false
