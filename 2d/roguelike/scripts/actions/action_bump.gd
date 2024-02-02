class_name ActionBump
extends ActionWithDirection


func perform() -> bool:
	if get_target_actor():
		return ActionMelee.new(entity, offset.x, offset.y).perform()
	else:
		return ActionMove.new(entity, offset.x, offset.y).perform()
