class_name GameRoot
extends Control


signal main_menu_requested

@onready var _game: Game = $"%Game"


func _ready() -> void:
	SignalBus.exit_requested.connect(_on_exit_requested)


func _on_exit_requested() -> void:
	main_menu_requested.emit()
