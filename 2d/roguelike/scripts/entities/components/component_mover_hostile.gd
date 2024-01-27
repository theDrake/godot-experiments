class_name ComponentMoverHostile
extends ComponentMover


var path: Array = []


func perform() -> void:
	var target: Entity = get_map_data().get_player()
	if target == null:
		return

	var target_grid_position: Vector2i = target.grid_position
	var offset: Vector2i = target_grid_position - entity.grid_position
	var distance: int = max(abs(offset.x), abs(offset.y))

	if get_map_data().get_tile(entity.grid_position).in_view:
		if distance <= 1:
			return ActionMelee.new(entity, offset.x, offset.y).perform()
		path = get_point_path_to(target_grid_position)
		path.pop_front()

	if not path.is_empty():
		var destination := Vector2i(path[0])
		if get_map_data().get_blocker_at(destination):
			return ActionWait.new(entity).perform()
		path.pop_front()
		var move_offset: Vector2i = destination - entity.grid_position
		return ActionMove.new(entity, move_offset.x, move_offset.y).perform()

	return ActionWait.new(entity).perform()
