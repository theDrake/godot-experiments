class_name MainMenu
extends Control


signal game_requested(load)

@onready var _new_button: Button = $"%NewButton"
@onready var _load_button: Button = $"%LoadButton"


func _ready() -> void:
	if FileAccess.file_exists(Game.SAVE_FILE):
		_load_button.grab_focus()
	else:
		_load_button.disabled = true
		_new_button.grab_focus()


func _on_new_button_pressed() -> void:
	game_requested.emit(false)


func _on_load_button_pressed() -> void:
	game_requested.emit(true)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
