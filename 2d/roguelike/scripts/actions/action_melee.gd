class_name ActionMelee
extends ActionWithDirection


func perform() -> void:
	var target: Entity = get_target_actor()
	if not target:
		return

	var damage: int = entity.fighter_type.power - target.fighter_type.defense
	var attack_description: String = "%s attacks %s" % [entity.entity_name,
			target.entity_name]
	if damage > 0:
		attack_description += " for %d hit points." % damage
		target.fighter_type.hp -= damage
	else:
		attack_description += ", but does no damage."
	print(attack_description)
