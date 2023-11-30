class_name PlayerBullet
extends Area2D
## Player bullet handler for a 2D shmup.
##
## Bullets move up, kill enemies, and disappear on exit.


@export var speed := -250.0


func start(spawn_point: Vector2) -> void:
	position = spawn_point


func _process(delta: float) -> void:
	position.y += speed * delta


func _on_area_entered(other: Area2D) -> void:
	if other.is_in_group("enemies"):
		other.explode()
		queue_free()


func _on_screen_exited() -> void:
	queue_free()
