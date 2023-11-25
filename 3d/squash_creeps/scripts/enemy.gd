class_name Enemy
extends CharacterBody3D


signal squashed

@export var min_speed := 10.0 # m/s
@export var max_speed := 18.0


func initialize(spawn_point: Vector3, player_position: Vector3) -> void:
	look_at_from_position(spawn_point, player_position)
	rotate_y(randf_range(-PI / 4, PI / 4))
	var speed := randf_range(min_speed, max_speed)
	velocity = (speed * Vector3.FORWARD).rotated(Vector3.UP, rotation.y)
	$AnimationPlayer.speed_scale = (speed * 1.5) / min_speed


func _physics_process(_delta: float) -> void:
	move_and_slide()


func squash() -> void:
	squashed.emit()
	queue_free()


func _on_screen_exited() -> void:
	queue_free()
