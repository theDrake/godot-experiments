class_name GameRoot
extends Control


signal main_menu_requested

@onready var _game: Game = $"%Game"


func _ready() -> void:
	SignalBus.exit_requested.connect(_on_exit_requested)


func new_game() -> void:
	_game.new_game()


func load_game() -> void:
	if not _game.load_game():
		main_menu_requested.emit()


func _on_exit_requested() -> void:
	main_menu_requested.emit()
