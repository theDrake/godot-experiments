class_name Game
extends Node2D


signal player_created(player)

const SAVE_FILE: String = "user://roguelike_save.dat"
const LEVEL_UP_MENU: PackedScene = preload("res://scenes/level_up_menu.tscn")

@onready var map: Map = $Map

@onready var _player: Entity
@onready var _input_handler: InputHandler = $InputHandler
@onready var _cam: Camera2D = $PlayerCamera


func _ready() -> void:
	SignalBus.save_requested.connect(save_game)


func new_game() -> void:
	_player = Entity.new(null, Vector2i.ZERO, "Player")
	player_created.emit(_player)
	remove_child(_cam)
	_player.add_child(_cam)
	_player.fighter.level_up_required.connect(_on_level_up_requested)
	map.generate(_player, 0)
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
	_player.fighter.level_up_required.connect(_on_level_up_requested)
	map.populate(map.data.current_depth)
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
	if action and action.perform():
		_handle_enemy_turns()
		map.update_fov(_player.grid_position)


func _handle_enemy_turns() -> void:
	var actors: Array[Entity] = map.data.get_actors()
	actors.shuffle()
	for actor in actors:
		if actor.alive() and actor != _player:
			actor.mover.perform()


func _on_level_up_requested() -> void:
	var level_up_menu: LevelUpMenu = LEVEL_UP_MENU.instantiate()
	add_child(level_up_menu)
	level_up_menu.init_buttons(_player)
	set_physics_process(false)
	await level_up_menu.level_up_completed
	set_physics_process.bind(true).call_deferred()
