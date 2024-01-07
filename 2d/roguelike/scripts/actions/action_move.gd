class_name ActionMove
extends Action


var offset: Vector2i


func _init(dx: int, dy: int) -> void:
	offset = Vector2i(dx, dy)


func perform(game: Game, entity: Entity) -> void:
	var destination_tile: Tile = game.get_map_data().get_tile(
			entity.grid_position + offset)

	if not destination_tile or not destination_tile.is_walkable():
		return

	entity.move(offset)
