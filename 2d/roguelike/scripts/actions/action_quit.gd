class_name ActionQuit
extends Action


func perform(game: Game, _entity: Entity) -> void:
	game.get_tree().quit()
