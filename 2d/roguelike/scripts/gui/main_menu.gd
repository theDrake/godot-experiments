class_name MainMenu
extends Control


signal game_requested(load)

@onready var _new_game_button: Button = $"%NewButton"
@onready var _load_game_button: Button = $"%LoadButton"


func _ready() -> void:
	_new_game_button.grab_focus()
	var save_file_exists: bool = FileAccess.file_exists(
			"user://roguelike_save.dat")
	_load_game_button.disabled = not save_file_exists


func _on_new_button_pressed() -> void:
	game_requested.emit(false)


func _on_load_button_pressed() -> void:
	game_requested.emit(true)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
