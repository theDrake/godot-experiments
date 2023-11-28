extends Node2D
## World manager for 'Flap' game.
##
## Keeps score text updated and restarts game after player dies.


func _process(_delta: float) -> void:
	$Score.text = "Score: " + str(Global.score)


func _on_player_died() -> void:
	$RestartTimer.start()


func _on_restart_timer_timeout() -> void:
	Global.score = 0
	get_tree().reload_current_scene()
