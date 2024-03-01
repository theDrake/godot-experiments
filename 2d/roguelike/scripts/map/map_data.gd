class_name MapData
extends RefCounted


signal entity_placed(entity)

const BLOCKER_PATHFINDING_WEIGHT: float = 10.0

var width: int
var height: int
var current_depth: int
var tiles: Array[Tile]
var entities: Array[Entity]
var pathfinder: AStarGrid2D


func _init(map_width: int, map_height: int) -> void:
	width = map_width
	height = map_height
	entities = []
	init_tiles()


func init_tiles() -> void:
	tiles = []
	for y in height:
		for x in width:
			var tile_position := Vector2i(x, y)
			var tile := Tile.new(tile_position, Tile.TileType.WALL)
			tiles.append(tile)


func init_pathfinder() -> void:
	pathfinder = AStarGrid2D.new()
	pathfinder.region = Rect2i(0, 0, width, height)
	pathfinder.update()
	for y in height:
		for x in width:
			var grid_position := Vector2i(x, y)
			var tile: Tile = get_tile(grid_position)
			pathfinder.set_point_solid(Vector2i(x, y), tile.blocks_movement())
	for entity in entities:
		if entity.blocks_movement:
			register_blocker(entity)


func get_tile(grid_pos: Vector2i) -> Tile:
	var tile_index: int = grid_to_index(grid_pos)
	if tile_index == -1:
		return null

	return tiles[tile_index]


func get_player() -> Entity:
	return entities[0]


func get_actors() -> Array[Entity]:
	var actors: Array[Entity] = []
	for entity in entities:
		if entity.alive():
			actors.append(entity)

	return actors


func get_items() -> Array[Entity]:
	var items: Array[Entity] = []
	for entity in entities:
		if entity.usable or entity.equipment:
			items.append(entity)

	return items


func get_actor_at(grid_position: Vector2i) -> Entity:
	for actor in get_actors():
		if actor.grid_position == grid_position:
			return actor

	return null


func get_blocker_at(grid_position: Vector2i) -> Entity:
	for entity in entities:
		if entity.blocks_movement and entity.grid_position == grid_position:
			return entity

	return null


func get_entity_at(grid_position: Vector2i) -> Entity:
	for e in entities:
		if e.grid_position == grid_position:
			return e

	return null


func register_blocker(entity: Entity) -> void:
	pathfinder.set_point_weight_scale(entity.grid_position,
		BLOCKER_PATHFINDING_WEIGHT)


func unregister_blocker(entity: Entity) -> void:
	pathfinder.set_point_weight_scale(entity.grid_position, 0)


func grid_to_index(grid_pos: Vector2i) -> int:
	if not in_bounds(grid_pos):
		return -1

	return grid_pos.y * width + grid_pos.x


func in_bounds(coordinate: Vector2i) -> bool:
	return (
			0 <= coordinate.x and coordinate.x < width
			and 0 <= coordinate.y and coordinate.y < height
	)


func get_save_data() -> Dictionary:
	var save_data := {
		"width": width,
		"height": height,
		"current_depth": current_depth,
		"tiles": [],
		"entities": [],
	}
	for e in entities:
		save_data["entities"].append(e.get_save_data())
	for t in tiles:
		save_data["tiles"].append(t.get_save_data())

	return save_data


func restore(save_data: Dictionary) -> void:
	width = save_data["width"]
	height = save_data["height"]
	current_depth = save_data["current_depth"]
	init_tiles()
	for i in tiles.size():
		tiles[i].restore(save_data["tiles"][i])
	init_pathfinder()
	entities = []
	for entity_data in save_data["entities"]:
		var new_entity := Entity.new(self, Vector2i.ZERO, "")
		new_entity.restore(entity_data)
		entities.append(new_entity)
	entities[0].is_player = true
	entities[0].map_data = self
