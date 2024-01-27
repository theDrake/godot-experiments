class_name ActionBump
extends ActionWithDirection


func perform() -> void:
	if get_target_actor():
		ActionMelee.new(entity, offset.x, offset.y).perform()
	else:
		ActionMove.new(entity, offset.x, offset.y).perform()
