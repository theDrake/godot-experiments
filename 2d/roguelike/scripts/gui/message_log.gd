class_name MessageLog
extends ScrollContainer


var _last_message: Message = null

@onready var _message_list: VBoxContainer = $"%MessageList"


func _ready() -> void:
	SignalBus.message_sent.connect(_add_message)


static func send_message(text: String, color: Color) -> void:
	SignalBus.message_sent.emit(text, color)


func _add_message(text: String, color: Color) -> void:
	if _last_message and _last_message.plain_text == text:
		_last_message.count += 1
	else:
		var message := Message.new(text, color)
		_last_message = message
		_message_list.add_child(message)
	await get_tree().process_frame
	ensure_control_visible(_last_message)
