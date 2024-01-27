class_name InputGameOver
extends InputBase


static func get_action(player: Entity) -> Action:
	if Input.is_action_just_pressed("quit"):
		return ActionQuit.new(player)

	return null
