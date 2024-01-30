class_name InputHistoryViewer
extends InputBase


const scroll_step = 16

@export_node_path("PanelContainer") var message_panel_path
@export_node_path("MessageLog") var message_log_path

@onready var _message_panel: PanelContainer = get_node(message_panel_path)
@onready var _message_log: MessageLog = get_node(message_log_path)


func enter() -> void:
	_message_panel.self_modulate = Color.GOLD


func exit() -> void:
	_message_panel.self_modulate = Color.WHITE


func get_action(player: Entity) -> Action:
	if Input.is_action_just_pressed("quit"):
		return ActionQuit.new(player)
	elif Input.is_action_just_pressed("view_history") or \
			Input.is_action_just_pressed("ui_back"):
		SignalBus.toggle_view_history.emit()
	elif Input.is_action_just_pressed("move_up"):
		_message_log.scroll_vertical -= scroll_step
	elif Input.is_action_just_pressed("move_down"):
		_message_log.scroll_vertical += scroll_step
	elif Input.is_action_just_pressed("move_left"):
		_message_log.scroll_vertical = 0
	elif Input.is_action_just_pressed("move_right"):
		_message_log.scroll_vertical = _message_log.get_v_scroll_bar().max_value

	return null
