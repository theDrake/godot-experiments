extends Node2D
## Conway's Game of Life: https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
##
## Based on a guide (https://gdscript.com/projects/game-of-life/), but with
## various fixes, tweaks, and improvements. Developed using Godot 4.1.


@export var cell_size := 30.0
@export var alive_color := Color.GREEN
@export var dead_color := Color.DARK_SLATE_GRAY

@export_category("Zoom")
@export var min_zoom := 0.05
@export var max_zoom := 1.5
@export var zoom_step := 0.1

var _grids := [{}, {}]
var _cells := {}
var _empty_cells_near_living_cells := []

@onready var _timer := $Timer as Timer
@onready var _cam := $Camera2D as Camera2D


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			place_cell(event.position)
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			remove_cell(event.position)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			change_zoom(-zoom_step)
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			change_zoom(zoom_step)
	if event is InputEventMouseMotion and \
			event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
		move_camera(event.relative)
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("ui_accept"):
		start_stop()
	if event.is_action_pressed("ui_reset"):
		reset()


func change_zoom(dz: float) -> void:
	var new_zoom = clamp(_cam.zoom.x + dz * _cam.zoom.x, min_zoom, max_zoom)
	_cam.zoom = Vector2(new_zoom, new_zoom)


func move_camera(dv: Vector2) -> void:
	_cam.offset -= dv / _cam.zoom.x


func place_cell(pos: Vector2) -> void:
	var grid_pos := get_grid_pos(mouse_pos_to_cam_pos(pos))
	if not _cells.has(grid_pos):
		add_new_cell(grid_pos)


func mouse_pos_to_cam_pos(pos: Vector2) -> Vector2:
	return pos + _cam.offset / _cam.zoom - get_viewport_rect().size / 2


func add_new_cell(grid_pos: Vector2) -> void:
	var pos: Vector2 = grid_pos * cell_size
	if _cells.has(grid_pos):
		_cells[grid_pos].color = alive_color
	else:
		var cell := ColorRect.new()
		cell.color = alive_color
		cell.size = Vector2(cell_size, cell_size)
		cell.position = pos
		add_child(cell)
		_cells[grid_pos] = cell
	_grids[1][grid_pos] = true


func remove_cell(pos: Vector2) -> void:
	var grid_pos := get_grid_pos(mouse_pos_to_cam_pos(pos))
	if _cells.has(grid_pos):
		_cells[grid_pos].queue_free()
		_cells.erase(grid_pos)
		_grids[1].erase(grid_pos)


func get_grid_pos(pos: Vector2) -> Vector2:
	var pixels: float = cell_size * _cam.zoom.x
	return pos.snapped(Vector2(pixels, pixels)) / pixels


func start_stop() -> void:
	if _timer.is_stopped() and _cells.size() > 0:
		_timer.start()
	else:
		_timer.stop()


func reset() -> void:
	_timer.stop()
	for key in _cells.keys():
		_cells[key].queue_free()
	_grids[1].clear()
	_cells.clear()


func _on_timer_timeout() -> void:
	_grids.reverse()
	_grids[1].clear()
	regenerate()
	add_new_cells()
	update_cells()


func regenerate() -> void:
	for key in _cells.keys():
		var n := get_num_live_cells(key, true)
		if _grids[0][key]: # alive
			_grids[1][key] = (n == 2 or n == 3)
		else: # dead
			_grids[1][key] = (n == 3)


func update_cells() -> void:
	for key in _cells.keys():
		_cells[key].color = alive_color if _grids[1][key] else dead_color


func get_num_live_cells(pos: Vector2, first_pass: bool) -> int:
	var num_live_cells := 0
	for y in [-1, 0, 1]:
		for x in [-1, 0, 1]:
			if x != 0 or y != 0:
				var new_pos := pos + Vector2(x, y)
				if _grids[0].has(new_pos):
					if _grids[0][new_pos]: # alive
						num_live_cells += 1
				elif first_pass:
					_empty_cells_near_living_cells.append(new_pos)
	return num_live_cells


func add_new_cells() -> void:
	for pos in _empty_cells_near_living_cells:
		var n := get_num_live_cells(pos, false)
		if n == 3 and not _grids[1].has(pos):
			add_new_cell(pos)
	_empty_cells_near_living_cells.clear()
