extends Node


@export var enemy_scene: PackedScene
var score: int


func new_game() -> void:
	get_tree().call_group("enemies", "queue_free")
	score = 0
	$UI.update_score(score)
	$UI.show_message("Get Ready")
	$Player.initialize($StartMarker.position)
	$StartTimer.start()
	$Music.play()


func game_over() -> void:
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	$Music.stop()
	$DeathSound.play()
	$UI.show_game_over()


func _on_start_timer_timeout() -> void:
	$ScoreTimer.start()
	$EnemyTimer.start()


func _on_score_timer_timeout() -> void:
	score += 1
	$UI.update_score(score)


func _on_enemy_timer_timeout() -> void:
	var enemy := enemy_scene.instantiate() as Enemy
	var spawn_point := $SpawnPath/PathFollow2D as PathFollow2D
	spawn_point.progress_ratio = randf()
	var direction := spawn_point.rotation + PI / 2 + randf_range(-PI / 4,
			PI / 4)
	enemy.position = spawn_point.position
	enemy.rotation = direction
	enemy.linear_velocity = Vector2(randf_range(enemy.MIN_VELOCITY,
			enemy.MAX_VELOCITY), 0.0).rotated(direction)
	add_child(enemy)
