class_name MouseWatcher
extends Node2D


signal entities_found(entity_list)

var _mouse_tile := Vector2i(-1, -1)

@onready var map: Map = get_parent()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var tile_position: Vector2i = Grid.world_to_grid(
				get_local_mouse_position())
		if _mouse_tile != tile_position:
			_mouse_tile = tile_position
			entities_found.emit(get_names_at(tile_position))


func get_names_at(grid_position: Vector2i) -> String:
	var entity_names := ""
	var tile: Tile = map.data.get_tile(grid_position)
	if tile and tile.in_view:
		var entity_array: Array[Entity] = []
		for entity in map.data.entities:
			if entity.grid_position == grid_position:
				entity_array.append(entity)
		entity_array.sort_custom(func(a, b): return a.z_index > b.z_index)
		if not entity_array.is_empty():
			entity_names = entity_array[0].entity_name
			for i in range(1, entity_array.size()):
				entity_names += ", %s" % entity_array[i].entity_name

	return entity_names