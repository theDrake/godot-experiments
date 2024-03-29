class_name MessageLog
extends ScrollContainer


@onready var _message_list: VBoxContainer = $"%MessageList"


func _ready() -> void:
	SignalBus.message_sent.connect(_add_message)


static func send_message(text: String, color: Color) -> void:
	SignalBus.message_sent.emit(text, color)


func _add_message(text: String, color: Color) -> void:
	var message := Message.new(text, color)
	_message_list.add_child(message)
	await get_tree().process_frame
	ensure_control_visible(message)
