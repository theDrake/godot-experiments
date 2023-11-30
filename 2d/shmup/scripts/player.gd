class_name ShmupPlayer
extends Area2D
## Player input handler for a 2D shmup.
##
## Handles movement, shooting, shielding, and death.


signal shield_changed
signal damaged
signal died

const MAX_SHIELD := 100.0

@export var speed := 150.0
@export var cooldown := 0.25
@export var bullet_scene: PackedScene

var _shield: float:
	set = _set_shield
var _can_shoot = true

@onready var _ship := $Ship
@onready var _boosters := $Ship/Boosters
@onready var _cooldown_timer := $CooldownTimer
@onready var _screensize := get_viewport_rect().size


func _ready() -> void:
	hide()
	set_process(false)


func start() -> void:
	position = Vector2(_screensize.x / 2, _screensize.y - 64)
	_shield = MAX_SHIELD
	_cooldown_timer.wait_time = cooldown
	show()
	set_process(true)


func _process(delta: float) -> void:
	var input := Input.get_vector("left", "right", "up", "down")
	if input.x > 0:
		_ship.frame = 2
		_boosters.animation = "right"
	elif input.x < 0:
		_ship.frame = 0
		_boosters.animation = "left"
	else:
		_ship.frame = 1
		_boosters.animation = "forward"
	position += input * speed * delta
	position = position.clamp(Vector2(8, 8), _screensize - Vector2(8, 8))
	if Input.is_action_pressed("shoot"):
		_shoot()


func _shoot() -> void:
	if not _can_shoot:
		return
	_can_shoot = false
	_cooldown_timer.start()
	var b := bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(position + Vector2(0, -8))
	var tween := create_tween().set_parallel(false)
	tween.tween_property(_ship, "position:y", 1, 0.1)
	tween.tween_property(_ship, "position:y", 0, 0.05)


func _on_cooldown_timeout() -> void:
	_can_shoot = true


func _set_shield(value: float) -> void:
	_shield = min(MAX_SHIELD, value)
	shield_changed.emit(_shield)
	if _shield <= 0:
		hide()
		set_process(false)
		died.emit()


func _on_area_entered(other: Area2D) -> void:
	if other.is_in_group("enemies"):
		other.explode()
		damaged.emit()
		_shield -= MAX_SHIELD / 4.0
	elif other is EnemyBullet:
		other.queue_free()
		damaged.emit()
		_shield -= MAX_SHIELD / 6.0
