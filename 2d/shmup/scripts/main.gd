extends Node2D
## Game manager for a 2D shmup.
##
## Handles the setup, starting, and ending of game sessions.


var _enemy := preload("res://scenes/enemy.tscn")
var _score := 0
var _playing := false

@onready var _start_button := $CanvasLayer/CenterContainer/Start
@onready var _game_over_rect := $CanvasLayer/CenterContainer/GameOver
@onready var _ui := $CanvasLayer/UI
@onready var _enemy_anchor := $EnemyAnchor
@onready var _player := $Player


func _ready() -> void:
	_game_over_rect.hide()
	_start_button.show()
	var tween := create_tween().set_loops().set_parallel(false).set_trans(
			Tween.TRANS_SINE)
	tween.tween_property(_enemy_anchor, "position:x",
			_enemy_anchor.position.x + 3, 1.0)
	tween.tween_property(_enemy_anchor, "position:x",
			_enemy_anchor.position.x - 3, 1.0)
	var tween2 := create_tween().set_loops().set_parallel(false).set_trans(
			Tween.TRANS_BACK)
	tween2.tween_property(_enemy_anchor, "position:y",
			_enemy_anchor.position.y + 3, 1.5).set_ease(Tween.EASE_IN_OUT)
	tween2.tween_property(_enemy_anchor, "position:y",
			_enemy_anchor.position.y - 3, 1.5).set_ease(Tween.EASE_IN_OUT)


func _process(_delta: float) -> void:
	if get_tree().get_nodes_in_group("enemies").size() == 0 and _playing:
		spawn_enemies()


func new_game() -> void:
	_score = 0
	_ui.update_score(_score)
	_player.start()
	spawn_enemies()
	_playing = true


func spawn_enemies() -> void:
	for x in range(9):
		for y in range(3):
			var e := _enemy.instantiate()
			var pos := Vector2(x * (16 + 8) + 24, 16 * 4 + y * 16)
			add_child(e)
			e.start(pos)
			e.anchor = _enemy_anchor
			e.died.connect(_on_enemy_died)


func _on_start_pressed() -> void:
	_start_button.hide()
	new_game()


func _on_enemy_died(points: int) -> void:
	_score += points
	_ui.update_score(_score)


func _on_player_died() -> void:
	_playing = false
	get_tree().call_group("enemies", "queue_free")
	_game_over_rect.show()
	await get_tree().create_timer(2).timeout
	_game_over_rect.hide()
	_start_button.show()
