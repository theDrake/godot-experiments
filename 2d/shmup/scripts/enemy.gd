class_name Enemy
extends Area2D
## Enemy handler for a 2D shmup.
##
## Handles movement, shooting, and death.


signal died

var anchor: Node2D

var _start_pos := Vector2.ZERO
var _speed := 0.0
var _bullet_scene := preload("res://scenes/enemy_bullet.tscn")
var _follow_anchor := false

@onready var _anim := $AnimationPlayer
@onready var _move_timer := $MoveTimer
@onready var _shoot_timer := $ShootTimer
@onready var _screensize := get_viewport_rect().size


func start(spawn_point: Vector2) -> void:
	_follow_anchor = false
	_speed = 0
	position = Vector2(spawn_point.x, -spawn_point.y)
	_start_pos = spawn_point
	await get_tree().create_timer(randf_range(0.25, 0.55)).timeout
	var tw := create_tween().set_trans(Tween.TRANS_BACK)
	tw.tween_property(self, "position:y", _start_pos.y, 1.4)
	await tw.finished
	_follow_anchor = true
	_move_timer.wait_time = randf_range(5, 20)
	_move_timer.start()
	_shoot_timer.wait_time = randf_range(4, 20)
	_shoot_timer.start()


func _process(delta: float) -> void:
	if _follow_anchor:
		position = _start_pos + anchor.position
	position.y += _speed * delta
	if position.y > _screensize.y + 32:
		start(_start_pos)


func explode() -> void:
	_speed = 0
	_anim.play("explode")
	set_deferred("monitorable", false)
	died.emit(5)
	await _anim.animation_finished
	queue_free()


func _on_move_timer_timeout() -> void:
	_speed = randf_range(75, 100)
	_follow_anchor = false


func _on_shoot_timer_timeout() -> void:
	var b := _bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(position)
	_shoot_timer.wait_time = randf_range(4, 20)
	_shoot_timer.start()
