class_name ActionQuit
extends Action


func perform() -> bool:
	SignalBus.exit_requested.emit()
	return false
