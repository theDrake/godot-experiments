class_name Tile
extends Sprite2D


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

var _def: TileDefinition


func _init(grid_position: Vector2i, tile_def: TileDefinition) -> void:
	visible = false
	centered = false
	position = Grid.grid_to_world(grid_position)
	set_tile_type(tile_def)


func set_tile_type(tile_def: TileDefinition) -> void:
	_def = tile_def
	texture = _def.texture
	modulate = _def.color_dark


func blocks_movement() -> bool:
	return _def.blocks_movement


func blocks_sight() -> bool:
	return _def.blocks_sight
