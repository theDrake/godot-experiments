class_name ActionMelee
extends ActionWithDirection


func perform() -> void:
	var target: Entity = get_target_actor()
	if not target:
		return

	var damage: int = entity.fighter_type.power - target.fighter_type.defense
	var attack_color: Color
	if entity == get_map_data().get_player():
		attack_color = GameColors.PLAYER_ATTACK
	else:
		attack_color = GameColors.ENEMY_ATTACK
	var attack_description: String = "%s attacks %s" % [entity.entity_name,
			target.entity_name]
	if damage > 0:
		attack_description += " for %d hit points." % damage
		target.fighter_type.hp -= damage
	else:
		attack_description += ", but does no damage."
	MessageLog.send_message(attack_description, attack_color)
