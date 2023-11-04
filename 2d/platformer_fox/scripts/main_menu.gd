extends Node2D
## Main menu for the 'Fox' platformer game.
##
## Provides buttons to 'Play' or 'Quit'.


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
