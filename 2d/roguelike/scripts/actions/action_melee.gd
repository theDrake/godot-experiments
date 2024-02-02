class_name ActionMelee
extends ActionWithDirection


func perform() -> bool:
	var target: Entity = get_target_actor()
	if not target:
		if entity.is_player:
			MessageLog.send_message("Nothing to attack.", GameColors.IMPOSSIBLE)
		return false

	var damage: int = entity.fighter.power - target.fighter.defense
	var attack_color: Color
	if entity.is_player:
		attack_color = GameColors.PLAYER_ATTACK
	else:
		attack_color = GameColors.ENEMY_ATTACK
	var attack_description: String = "%s attacks %s" % [entity.entity_name,
			target.entity_name]
	if damage > 0:
		attack_description += " for %d hit points." % damage
		target.fighter.hp -= damage
	else:
		attack_description += ", but does no damage."
	MessageLog.send_message(attack_description, attack_color)

	return true
