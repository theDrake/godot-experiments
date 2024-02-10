class_name Message
extends Label


const base_label_settings: LabelSettings = preload(
		"res://resources/message_label_settings.tres")


func _init(msg_text: String, msg_color: Color) -> void:
	label_settings = base_label_settings.duplicate()
	label_settings.font_color = msg_color
	autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text = msg_text
