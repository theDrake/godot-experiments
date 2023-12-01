extends Area2D


func _on_wall_area_entered(other: Area2D) -> void:
	if other.name == "Ball":
		other.reset()
