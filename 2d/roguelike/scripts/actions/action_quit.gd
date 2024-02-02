class_name ActionQuit
extends Action


func perform() -> bool:
	entity.get_tree().quit()
	return false
