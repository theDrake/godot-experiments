class_name ActionGet
extends Action


func perform() -> bool:
	var map_data: MapData = get_map_data()
	for item in map_data.get_items():
		if entity.grid_position == item.grid_position:
			if entity.inventory.items.size() >= entity.inventory.capacity:
				MessageLog.send_message("Your inventory is full.",
						GameColors.IMPOSSIBLE)
				return false
			map_data.entities.erase(item)
			item.get_parent().remove_child(item)
			entity.inventory.items.append(item)
			MessageLog.send_message("You got a %s." % item.entity_name,
					GameColors.DEFAULT)
			return true

	MessageLog.send_message("There's nothing here to get.",
			GameColors.IMPOSSIBLE)
	return false
