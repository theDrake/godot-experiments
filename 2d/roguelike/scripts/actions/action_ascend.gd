class_name ActionAscend
extends Action


func perform() -> bool:
	if get_map_data().get_tile(entity.grid_position).type == \
			Tile.TileType.STAIRS_UP:
		#SignalBus.player_ascended.emit()
		MessageLog.send_message("Not implemented yet.", GameColors.TRAVEL)
	else:
		MessageLog.send_message("There's no way to ascend here.",
				GameColors.IMPOSSIBLE)

	return false # ensure player has another turn either way
