class_name Reticle
extends Node2D


signal position_selected(grid_position)

const AREA_OF_EFFECT_COLOR: Color = Color(0.5, 0, 0, 0.3)

var _grid_position: Vector2i:
	set(value):
		_grid_position = value
		position = Grid.grid_to_world(_grid_position)
var _map_data: MapData
var _area_of_effect_vector: Vector2i

@onready var _reticle_cam: Camera2D = $ReticleCamera
@onready var _player_cam: Camera2D = %PlayerCamera


func _ready() -> void:
	hide()
	set_physics_process(false)


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		position_selected.emit(_grid_position)
	elif Input.is_action_just_pressed("ui_back"):
		position_selected.emit(Vector2i(-1, -1))
	else:
		var offset := Vector2i.ZERO
		for direction in InputMain.DIRECTIONS:
			if Input.is_action_just_pressed(direction):
				offset += InputMain.DIRECTIONS[direction]
		_grid_position += offset


func _draw():
	if _area_of_effect_vector.x > 0:
		draw_rect(Rect2(-_area_of_effect_vector, Vector2i(
				_area_of_effect_vector.x * 2 + Grid.TILE_SIZE.x,
				_area_of_effect_vector.y * 2 + Grid.TILE_SIZE.y)),
				AREA_OF_EFFECT_COLOR)


func select_position(player: Entity, radius: int) -> Vector2i:
	_map_data = player.map_data
	_grid_position = player.grid_position
	_reticle_cam.make_current()
	_area_of_effect_vector = radius * Grid.TILE_SIZE
	show()
	await get_tree().physics_frame
	set_physics_process.call_deferred(true)

	var selected_position: Vector2i = await position_selected

	set_physics_process(false)
	_player_cam.make_current()
	_area_of_effect_vector = Vector2i.ZERO
	hide()

	return selected_position
