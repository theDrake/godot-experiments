class_name InputGameOver
extends InputBase


func get_action(player: Entity) -> Action:
	if Input.is_action_just_pressed("quit") or \
			Input.is_action_just_pressed("ui_back"):
		return ActionQuit.new(player)
	elif Input.is_action_just_pressed("view_history"):
		SignalBus.toggle_view_history.emit()

	return null
