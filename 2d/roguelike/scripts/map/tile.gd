class_name Tile
extends Sprite2D


var _def: TileDefinition


func _init(grid_position: Vector2i, tile_def: TileDefinition) -> void:
	centered = false
	position = Grid.grid_to_world(grid_position)
	set_tile_type(tile_def)


func set_tile_type(tile_def: TileDefinition) -> void:
	_def = tile_def
	texture = _def.texture
	modulate = _def.color_dark


func is_walkable() -> bool:
	return _def.is_walkable


func is_transparent() -> bool:
	return _def.is_transparent
