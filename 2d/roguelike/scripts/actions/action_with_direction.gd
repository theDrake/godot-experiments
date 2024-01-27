class_name ActionWithDirection
extends Action


var offset: Vector2i


func _init(e: Entity, dx: int, dy: int) -> void:
	super._init(e)
	offset = Vector2i(dx, dy)


func get_target_actor() -> Entity:
	return get_map_data().get_actor_at(get_destination())


func get_blocker_at_destination() -> Entity:
	return get_map_data().get_blocker_at(get_destination())


func get_destination() -> Vector2i:
	return entity.grid_position + offset
