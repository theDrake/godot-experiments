class_name ComponentHealing
extends ComponentUsable


func _init(def: ComponentHealingDefinition) -> void:
	super._init(def)


func use(action: ActionUse) -> bool:
	var amount_recovered: int = action.entity.fighter.heal(maxi(1, randi_range(
			power / 2, power) + action.entity.fighter.get_spell_potency() / 2))

	if amount_recovered > 0:
		MessageLog.send_message("You consume the %s and recover %d HP." %
				[entity.entity_name, amount_recovered],
				GameColors.HEALTH_RECOVERED)
		consume(action.entity)
		return true

	MessageLog.send_message("Your health is already full.", GameColors.INVALID)

	return false
