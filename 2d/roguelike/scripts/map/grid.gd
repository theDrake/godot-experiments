class_name Grid
extends Object


const TILE_SIZE := Vector2i(16, 16)


static func grid_to_world(grid_pos: Vector2i) -> Vector2i:
	var world_pos: Vector2i = grid_pos * TILE_SIZE
	return world_pos


static func world_to_grid(world_pos: Vector2i) -> Vector2i:
	var grid_pos: Vector2i = world_pos / TILE_SIZE
	return grid_pos
