class_name ActionWait
extends Action


func perform() -> bool:
	if entity.is_player:
		MessageLog.send_message("Waiting...", GameColors.DEFAULT)

	return true
