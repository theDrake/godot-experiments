extends Area2D


@export var _bounce_direction := 1.0


func _on_area_entered(other: Area2D) -> void:
	if other.name == "Ball":
		other.direction = (other.direction +
				Vector2(0, _bounce_direction)).normalized()
