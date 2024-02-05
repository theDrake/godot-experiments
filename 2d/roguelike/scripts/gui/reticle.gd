class_name Reticle
extends Node2D


signal position_selected(grid_position)

var _grid_position: Vector2i:
	set(value):
		_grid_position = value
		position = Grid.grid_to_world(_grid_position)
var _map_data: MapData

@onready var _cam: Camera2D = $ReticleCamera


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


func select_position(player: Entity, radius: int) -> Vector2i:
	_map_data = player.map_data
	_grid_position = player.grid_position
	var player_camera: Camera2D = get_viewport().get_camera_2d()
	_cam.make_current()
	show()
	await get_tree().physics_frame
	set_physics_process.call_deferred(true)
	var selected_position: Vector2i = await position_selected
	set_physics_process(false)
	player_camera.make_current()
	hide()

	return selected_position
