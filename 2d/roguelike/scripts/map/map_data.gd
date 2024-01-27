class_name MapData
extends RefCounted


const TILE_TYPES = {
	"floor": preload("res://resources/tile_definition_floor.tres"),
	"wall": preload("res://resources/tile_definition_wall.tres"),
}
const BLOCKER_PATHFINDING_WEIGHT: float = 10.0

var width: int
var height: int
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
			var tile := Tile.new(tile_position, TILE_TYPES.wall)
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


func get_actor_at(location: Vector2i) -> Entity:
	for actor in get_actors():
		if actor.grid_position == location:
			return actor

	return null


func get_blocker_at(grid_position: Vector2i) -> Entity:
	for entity in entities:
		if entity.blocks_movement and entity.grid_position == grid_position:
			return entity

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
