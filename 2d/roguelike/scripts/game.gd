class_name Game
extends Node2D


signal player_created(player)

const PlayerDef: EntityDefinition = preload(
		"res://resources/entity_player.tres")

@onready var map: Map = $Map
@onready var _player: Entity
@onready var _input_handler: InputHandler = $InputHandler


func _ready() -> void:
	_player = Entity.new(null, Vector2i.ZERO, PlayerDef)
	_player.is_player = true
	player_created.emit(_player)
	var camera := $Camera2D
	remove_child(camera)
	_player.add_child(camera)
	map.generate(_player)
	map.update_fov(_player.grid_position)
	MessageLog.send_message.bind("Welcome, adventurer!",
			GameColors.WELCOME_TEXT).call_deferred()
	camera.make_current.call_deferred()


func _physics_process(_delta: float) -> void:
	var action: Action = await _input_handler.get_action(_player)
	if action:
		#var prev_grid_pos: Vector2i = _player.grid_position
		if action.perform():
			_handle_enemy_turns()
			map.update_fov(_player.grid_position)


func get_map_data() -> MapData:
	return map.data


func _handle_enemy_turns() -> void:
	for entity in get_map_data().get_actors():
		if entity.alive() and entity != _player:
			entity.mover.perform()
