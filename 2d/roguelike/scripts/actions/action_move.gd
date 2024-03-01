class_name ActionMove
extends ActionWithDirection


func perform() -> bool:
	var destination_tile: Tile = entity.map_data.get_tile(get_destination())
	if not destination_tile or destination_tile.blocks_movement() or \
			get_blocker_at_destination():
		if entity.is_player:
			MessageLog.send_message("That way is blocked.",
					GameColors.IMPOSSIBLE)
		return false
	entity.move(offset)

	return true
