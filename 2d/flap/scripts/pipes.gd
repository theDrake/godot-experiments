extends TileMap
## Pipe generator for 'Flap' game.
##
## Creates two leftward-moving vertical pipes and adds points to Global.score
## if the player passes through the gap between pipes.


const SCROLL_SPEED := 80
const NUM_COLORS := 8
const TILES_PER_COLOR := 3
const MIN_PIPE_LEN := 1
const MAX_PIPE_LEN := 16
const MIN_PIPE_GAP := 7
const MAX_PIPE_GAP := 10
const CELL_X := 7 # beyond right side of screen

var _points := 12 # reduced by pipe gap in _ready()


func _ready() -> void:
	# top pipe
	var tile := _rand_pipe_tile()
	var top_pipe_len := randi_range(MIN_PIPE_LEN, MAX_PIPE_LEN)
	for i in top_pipe_len:
		set_cell(0, Vector2i(CELL_X, i), 0, Vector2i(tile.x, tile.y), 0)
	set_cell(0, Vector2i(CELL_X, top_pipe_len), 0,
			Vector2i(tile.x, tile.y - 1), 0)

	# bottom pipe
	tile = _rand_pipe_tile()
	var gap := randi_range(MIN_PIPE_GAP, MAX_PIPE_GAP)
	_points -= gap
	set_cell(0, Vector2i(CELL_X, top_pipe_len + gap - 1), 0,
			Vector2i(tile.x, tile.y + 1), 0)
	for i in MAX_PIPE_LEN:
		set_cell(0, Vector2i(CELL_X, top_pipe_len + gap + i), 0,
				Vector2i(tile.x, tile.y), 0)


func _process(delta: float) -> void:
	position.x -= SCROLL_SPEED * delta


func _on_points_zone_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		Global.score += _points


func _rand_pipe_tile() -> Vector2i:
	var tile_x := randi_range(0, NUM_COLORS - 1)
	var tile_y := 1
	if tile_x >= NUM_COLORS / 2:
		tile_x -= NUM_COLORS / 2
		tile_y += TILES_PER_COLOR

	return Vector2i(tile_x, tile_y)
