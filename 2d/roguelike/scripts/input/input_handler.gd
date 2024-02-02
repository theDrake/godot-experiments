class_name InputHandler
extends Node


var _current_input_mode: Object
var _previous_input_mode: Object

@onready var _input_main: InputMain = $Main
@onready var _input_game_over: InputGameOver = $GameOver
@onready var _input_game_paused: InputBase = $GamePaused
@onready var _input_history_viewer: InputHistoryViewer = $HistoryViewer


func _ready() -> void:
	_transition_to(_input_main)
	SignalBus.player_died.connect(_transition_to.bind(_input_game_over))
	SignalBus.toggle_pause.connect(_toggle_pause)
	SignalBus.toggle_view_history.connect(_toggle_view_history)


func get_action(player: Entity) -> Action:
	if _current_input_mode:
		return await _current_input_mode.get_action(player)

	return null


func _transition_to(mode: Object) -> void:
	if _current_input_mode:
		_previous_input_mode = _current_input_mode
		_current_input_mode.exit()
	_current_input_mode = mode
	_current_input_mode.enter()


func _toggle_pause() -> void:
	if _current_input_mode == _input_game_paused:
		_transition_to(_previous_input_mode)
	else:
		_transition_to(_input_game_paused)


func _toggle_view_history() -> void:
	if _current_input_mode == _input_history_viewer:
		_transition_to(_previous_input_mode)
	else:
		_transition_to(_input_history_viewer)
