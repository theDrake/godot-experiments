class_name Tile
extends Sprite2D


enum TileType {
	FLOOR,
	STAIRS_DOWN,
	WALL,
}

const TILES = [
	preload("res://resources/tile_floor.tres"),
	preload("res://resources/tile_stairs_down.tres"),
	preload("res://resources/tile_wall.tres"),
]

var in_view: bool = false:
	set(value):
		in_view = value
		modulate = _def.color_lit if in_view else _def.color_dark
		if in_view and not explored:
			explored = true
var explored: bool = false:
	set(value):
		explored = value
		if explored and not visible:
			visible = true
var type: TileType

var _def: TileDefinition


func _init(grid_position: Vector2i, tile_type: int) -> void:
	visible = false
	centered = false
	position = Grid.grid_to_world(grid_position)
	set_tile_type(tile_type as TileType)


func set_tile_type(tile_type: TileType) -> void:
	type = tile_type
	_def = TILES[type]
	texture = _def.texture
	modulate = _def.color_dark


func blocks_movement() -> bool:
	return _def.blocks_movement


func blocks_sight() -> bool:
	return _def.blocks_sight


func get_save_data() -> Dictionary:
	return {
		"type": type,
		"explored": explored,
	}


func restore(save_data: Dictionary) -> void:
	set_tile_type(save_data["type"])
	explored = save_data["explored"]
