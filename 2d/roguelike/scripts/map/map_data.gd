class_name MapData
extends RefCounted


const TILE_TYPES = {
	"Floor": preload("res://resources/tile_definition_floor.tres"),
	"Wall": preload("res://resources/tile_definition_wall.tres"),
}

var width: int
var height: int
var tiles: Array[Tile]


func _init(map_width: int, map_height: int) -> void:
	width = map_width
	height = map_height
	_setup_tiles()


func _setup_tiles() -> void:
	tiles = []

	for y in height:
		for x in width:
			var tile_position := Vector2i(x, y)
			var tile := Tile.new(tile_position, TILE_TYPES.Wall)
			tiles.append(tile)


func get_tile(grid_pos: Vector2i) -> Tile:
	var tile_index: int = grid_to_index(grid_pos)
	if tile_index == -1:
		return null

	return tiles[tile_index]


func grid_to_index(grid_pos: Vector2i) -> int:
	if not in_bounds(grid_pos):
		return -1

	return grid_pos.y * width + grid_pos.x


func in_bounds(coordinate: Vector2i) -> bool:
	return (
			0 <= coordinate.x and coordinate.x < width
			and 0 <= coordinate.y and coordinate.y < height
	)
