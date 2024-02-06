class_name GameManager
extends Node


const GAME_SCENE: PackedScene = preload("res://scenes/game.tscn")
const MAIN_MENU_SCENE: PackedScene = preload("res://scenes/main_menu.tscn")

var _current_scene: Node


func _ready() -> void:
	load_main_menu()


func load_main_menu() -> void:
	var main_menu: MainMenu = load_scene(MAIN_MENU_SCENE)
	main_menu.game_requested.connect(_on_game_requested)


func load_scene(scene: PackedScene) -> Node:
	if _current_scene:
		_current_scene.queue_free()
	_current_scene = scene.instantiate()
	add_child(_current_scene)

	return _current_scene


func _on_game_requested(try_load: bool) -> void:
	var game: GameRoot = load_scene(GAME_SCENE)
	game.main_menu_requested.connect(load_main_menu)
