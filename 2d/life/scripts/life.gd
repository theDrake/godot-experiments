extends Node2D
## Conway's Game of Life: https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
##
## Based on a guide (https://gdscript.com/projects/game-of-life/), but with
## many tweaks, fixes, additions, and improvements. Developed using Godot 4.1.


@export var cell_size := 20
@export var alive_color := Color.GREEN
@export var dead_color := Color.DARK_SLATE_GRAY

@export_category("Zoom")
@export var min_zoom := 0.1
@export var max_zoom := 2.0
@export var zoom_step := 0.1

var _grids := [{}, {}]
var _cells := {}
var _empty_cells_near_living_cells := []

@onready var _mouse_indicator := $MouseIndicator as ReferenceRect
@onready var _timer := $Timer as Timer
@onready var _cam := $Camera2D as Camera2D


func _ready() -> void:
	_mouse_indicator.size = Vector2i(cell_size, cell_size)


func _process(_delta: float) -> void:
	var grid_pos := get_grid_pos(get_global_mouse_position())
	_mouse_indicator.position = get_pixel_pos(grid_pos)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		add_cell(grid_pos)
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		remove_cell(grid_pos)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and \
			event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
		move_camera(event.relative)
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			change_zoom(-zoom_step)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			change_zoom(zoom_step)
	elif event.is_action_pressed("ui_accept"):
		play_or_pause()
	elif event.is_action_pressed("ui_reset"):
		reset()
	elif event.is_action_pressed("ui_cancel"):
		if _timer.is_stopped():
			if _cells.size() > 0:
				reset()
			else:
				get_tree().quit()
		else:
			_timer.stop()


func change_zoom(dz: float) -> void:
	var new_zoom = clamp(_cam.zoom.x + dz * _cam.zoom.x, min_zoom, max_zoom)
	_cam.zoom = Vector2(new_zoom, new_zoom)


func move_camera(dv: Vector2) -> void:
	_cam.offset -= dv / _cam.zoom.x


func get_grid_pos(mouse_pos: Vector2) -> Vector2i:
	return mouse_pos.snapped(Vector2i(cell_size, cell_size)) / cell_size


func get_pixel_pos(grid_pos: Vector2i) -> Vector2i:
	var half_cell_size := roundi(cell_size * 0.5)
	return (grid_pos * cell_size) - Vector2i(half_cell_size, half_cell_size)


func add_cell(grid_pos: Vector2i) -> void:
	if _cells.has(grid_pos):
		_cells[grid_pos].color = alive_color
	else:
		var cell := ColorRect.new()
		cell.color = alive_color
		cell.size = Vector2i(cell_size, cell_size)
		cell.position = get_pixel_pos(grid_pos)
		add_child(cell)
		_cells[grid_pos] = cell
	_grids[1][grid_pos] = true


func remove_cell(grid_pos: Vector2i) -> void:
	if _cells.has(grid_pos):
		_cells[grid_pos].queue_free()
		_cells.erase(grid_pos)
		_grids[1].erase(grid_pos)


func play_or_pause() -> void:
	if _timer.is_stopped() and _cells.size() > 0:
		_timer.start()
	else:
		_timer.stop()


func reset() -> void:
	_timer.stop()
	for grid_pos in _cells:
		_cells[grid_pos].queue_free()
	_grids[1].clear()
	_cells.clear()


func _on_timer_timeout() -> void:
	_grids.reverse()
	_grids[1].clear()
	check_for_cell_death()
	check_for_cell_birth()
	update_cell_colors()


func check_for_cell_death() -> void:
	for grid_pos in _cells:
		var n := num_live_neighbors(grid_pos, true)
		if _grids[0][grid_pos]: # alive
			_grids[1][grid_pos] = (n == 2 or n == 3)
		else: # dead
			_grids[1][grid_pos] = (n == 3)


func check_for_cell_birth() -> void:
	for pos in _empty_cells_near_living_cells:
		var n := num_live_neighbors(pos, false)
		if n == 3 and not _grids[1].has(pos):
			add_cell(pos)
	_empty_cells_near_living_cells.clear()


func update_cell_colors() -> void:
	for grid_pos in _cells:
		_cells[grid_pos].color = alive_color if _grids[1][grid_pos] else \
				dead_color


func num_live_neighbors(pos: Vector2i, first_pass: bool) -> int:
	var num_live_cells := 0
	for y in [-1, 0, 1]:
		for x in [-1, 0, 1]:
			if x != 0 or y != 0:
				var new_pos := pos + Vector2i(x, y)
				if _grids[0].has(new_pos):
					if _grids[0][new_pos]: # alive
						num_live_cells += 1
				elif first_pass:
					_empty_cells_near_living_cells.append(new_pos)
	return num_live_cells
