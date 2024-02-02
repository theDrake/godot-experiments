class_name ComponentMover
extends Component


func perform() -> bool:
	return false


func get_point_path_to(v: Vector2i) -> PackedVector2Array:
	return get_map_data().pathfinder.get_point_path(entity.grid_position, v)
