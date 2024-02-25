class_name ActionDescend
extends Action


func perform() -> bool:
	if get_map_data().get_tile(entity.grid_position).type == \
			Tile.TileType.STAIRS_DOWN:
		SignalBus.player_descended.emit()
		MessageLog.send_message("You descend the staircase.", GameColors.TRAVEL)
	else:
		MessageLog.send_message("There's no way to descend here.",
				GameColors.IMPOSSIBLE)

	return false # ensure player has another turn either way
