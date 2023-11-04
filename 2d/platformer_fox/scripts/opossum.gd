extends AnimatableBody2D
## Opossum handler for the 'Fox' platformer game.
##
## Opossums move back and forth on platforms. If they sense the player, they
## pursue at high speed to attack. If jumped on, they die.


const WALK_SPEED := 50.0
const RUN_SPEED := WALK_SPEED * 3.0
const ATTACK_POWER := 1
const POINTS_VALUE := 10

var _speed := WALK_SPEED
var _direction := -1
var _target: Node2D = null
var _dead = false

@onready var _anim := $AnimatedSprite2D as AnimatedSprite2D
@onready var _ray := $RayCast2D as RayCast2D


func _physics_process(delta: float) -> void:
	if _dead:
		return

	if _target: # pursue target
		if not _target.alive():
			_target = null
			return

		var new_direction = (_target.position - position).x
		if (new_direction > 0 and _direction == -1) or \
				(new_direction < 0 and _direction == 1):
			_flip_direction()

	if _ray.is_colliding(): # safe to move forward
		position.x += _direction * _speed * delta
	elif not _target: # at cliff edge: turn (unless pursuing a target)
		_flip_direction()


func _flip_direction() -> void:
	_direction *= -1
	_ray.position.x *= -1
	_anim.flip_h = not _anim.flip_h


func _on_sensor_area_body_entered(body: Node2D) -> void:
	if not _dead and body.name.begins_with("Play") and body.alive():
		_target = body
		_speed = RUN_SPEED
		_anim.play("run")


func _on_sensor_area_body_exited(body: Node2D) -> void:
	if not _dead and body.name.begins_with("Play"):
		_target = null
		_speed = WALK_SPEED
		_anim.play("walk")


func _on_attack_area_body_entered(body: Node2D) -> void:
	if not _dead and body.name.begins_with("Play"):
		body.reduce_health(ATTACK_POWER)


func _on_top_area_body_entered(body: Node2D) -> void:
	if not _dead and body.name.begins_with("Play"):
		_dead = true
		$CollisionShape2D.queue_free()
		body.add_points(POINTS_VALUE)
		_anim.play("die")
		await _anim.animation_finished
		queue_free()
