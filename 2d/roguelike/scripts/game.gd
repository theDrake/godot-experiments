class_name Game
extends Node2D


signal player_created(player)

const SAVE_FILE: String = "user://roguelike_save.dat"

@onready var map: Map = $Map

@onready var _player: Entity
@onready var _input_handler: InputHandler = $InputHandler
@onready var _cam: Camera2D = $Camera2D


func _ready() -> void:
	SignalBus.exit_requested.connect(save_game)


func new_game() -> void:
	_player = Entity.new(null, Vector2i.ZERO, "Player")
	player_created.emit(_player)
	remove_child(_cam)
	_player.add_child(_cam)
	map.generate(_player)
	map.update_fov(_player.grid_position)
	MessageLog.send_message.bind("Welcome, adventurer!",
			GameColors.WELCOME_TEXT).call_deferred()
	_cam.make_current.call_deferred()


func load_game() -> bool:
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if not file:
		return false
	#var retrieved_hash: String = file.get_line()
	#var save_string: String = file.get_line()
	#var calculated_hash: String = save_string.sha256_text()
	#var valid_hash: bool = retrieved_hash == calculated_hash
	#if not valid_hash:
		#return false
	map.data = MapData.new(0, 0)
	map.data.restore(JSON.parse_string(file.get_line()))
	_player = map.data.get_player()
	remove_child(_cam)
	_player.add_child(_cam)
	map.populate()
	player_created.emit(_player)
	map.update_fov(_player.grid_position)
	MessageLog.send_message.bind("Welcome back, adventurer!",
			GameColors.WELCOME_TEXT).call_deferred()
	_cam.make_current.call_deferred()

	return true


func save_game() -> bool:
	if _player.alive():
		var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
		if file:
			#var save_hash: String = save_string.sha256_text()
			#file.store_line(save_hash)
			file.store_line(JSON.stringify(map.data.get_save_data()))
			return true

	return false


func _physics_process(_delta: float) -> void:
	var action: Action = await _input_handler.get_action(_player)
	if action:
		#var prev_grid_pos: Vector2i = _player.grid_position
		if action.perform():
			_handle_enemy_turns()
			map.update_fov(_player.grid_position)


func _handle_enemy_turns() -> void:
	for entity in map.data.get_actors():
		if entity.alive() and entity != _player:
			entity.mover.perform()
