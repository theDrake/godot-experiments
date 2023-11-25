extends CharacterBody3D


signal died

@export var speed := 14.0 # m/s
@export var fall_acceleration := 75.0 # m/s^2
@export var jump_impulse := 24.0
@export var bounce_impulse := 20.0

var target_velocity := Vector3.ZERO


func _physics_process(delta: float) -> void:
	var direction := Vector3.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	if not is_on_floor():
		target_velocity.y -= fall_acceleration * delta
	elif Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse

	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		if collision.get_collider() == null:
			continue
		elif collision.get_collider().is_in_group("enemies"):
			var enemy := collision.get_collider() as Enemy
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				enemy.squash()
				target_velocity.y = bounce_impulse

	velocity = target_velocity
	move_and_slide()
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse


func _die() -> void:
	died.emit()
	queue_free()


func _on_enemy_sensor_body_entered(body: Node3D) -> void:
	_die()
