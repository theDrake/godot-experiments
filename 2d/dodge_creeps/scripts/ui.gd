extends CanvasLayer


signal start_game


func show_message(text: String) -> void:
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()


func show_game_over() -> void:
	show_message("Game Over")
	await $MessageTimer.timeout
	$MessageLabel.text = "Dodge the Creeps!"
	$MessageLabel.show()
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()


func update_score(score: int) -> void:
	$ScoreLabel.text = str(score)


func _on_message_timer_timeout() -> void:
	$MessageLabel.hide()


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()
