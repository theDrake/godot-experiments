class_name ComponentInventory
extends Component


var items: Array[Entity]
var capacity: int


func _init(inventory_capacity: int) -> void:
	items = []
	capacity = inventory_capacity


func drop(item: Entity) -> bool:
	if not item:
		return false

	items.erase(item)
	var map_data: MapData = get_map_data()
	map_data.entities.append(item)
	map_data.entity_placed.emit(item)
	item.map_data = map_data
	item.grid_position = entity.grid_position
	MessageLog.send_message("You dropped a %s." % item.entity_name,
			GameColors.DEFAULT)

	return true


func get_save_data() -> Dictionary:
	var save_data: Dictionary = {
		"capacity": capacity,
		"items": []
	}
	for i in items:
		save_data["items"].append(i.get_save_data())

	return save_data


func restore(save_data: Dictionary) -> void:
	capacity = save_data["capacity"]
	for i in save_data["items"]:
		var item: Entity = Entity.new(null, Vector2i(-1, -1), "")
		item.restore(i)
		items.append(item)
