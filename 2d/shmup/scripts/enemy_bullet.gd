class_name EnemyBullet
extends Area2D
## Enemy bullet handler for a 2D shmup.
##
## Bullets move down, deplete player's shield, and disappear on exit.


@export var speed := 150.0


func start(spawn_point: Vector2) -> void:
	position = spawn_point


func _process(delta: float) -> void:
	position.y += speed * delta


func _on_screen_exited() -> void:
	queue_free()
