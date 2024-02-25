class_name ActionQuit
extends Action


func perform() -> bool:
	SignalBus.save_requested.emit()
	SignalBus.exit_requested.emit()

	return false
