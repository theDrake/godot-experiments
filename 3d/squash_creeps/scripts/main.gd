extends Node


@export var enemy_scene: PackedScene


func _ready() -> void:
	$UI/RetryScreen.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and $UI/RetryScreen.visible:
		get_tree().reload_current_scene()


func _on_spawn_timer_timeout() -> void:
	var enemy := enemy_scene.instantiate() as Enemy
	var spawn_point := $SpawnPath/PathFollow3D
	spawn_point.progress_ratio = randf()
	enemy.initialize(spawn_point.position, $Player.position)
	enemy.squashed.connect($UI/ScoreLabel._on_enemy_squashed.bind())
	add_child(enemy)


func _on_player_died() -> void:
	$SpawnTimer.stop()
	$UI/RetryScreen.show()
