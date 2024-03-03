class_name ActionMelee
extends ActionWithDirection


func perform() -> bool:
	var target: Entity = get_target_actor()
	if not target:
		return false

	var damage: int = maxi(entity.fighter.power - target.fighter.defense, 1)
	var attack_color: Color
	var attack_description: String
	if entity.is_player:
		attack_color = GameColors.PLAYER_ATTACK
		attack_description = "You attack %s" % target.entity_name
	else:
		attack_color = GameColors.ENEMY_ATTACK
		attack_description = "%s attacks %s" % [entity.entity_name,
				"you" if target.is_player else target.entity_name]
	attack_description += " for %d damage." % damage
	MessageLog.send_message(attack_description, attack_color)
	target.fighter.hp -= damage

	return true
