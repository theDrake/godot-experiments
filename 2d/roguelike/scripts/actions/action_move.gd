class_name ActionMove
extends ActionWithDirection


func perform() -> void:
	var destination_tile: Tile = get_map_data().get_tile(get_destination())
	if not destination_tile or destination_tile.blocks_movement():
		return
	elif get_blocker_at_destination():
		return

	entity.move(offset)
