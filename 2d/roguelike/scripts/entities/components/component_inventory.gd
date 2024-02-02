class_name ComponentInventory
extends Component


var items: Array[Entity]
var capacity: int


func _init(capacity: int) -> void:
	items = []
	self.capacity = capacity


func drop(item: Entity) -> bool:
	if not item:
		return false

	items.erase(item)
	var map_data: MapData = get_map_data()
	map_data.entities.append(item)
	map_data.entity_placed.emit(item)
	item.map_data = map_data
	item.grid_position = entity.grid_position
	MessageLog.send_message("You dropped a %s." % item.entity_name, Color.WHITE)

	return true
