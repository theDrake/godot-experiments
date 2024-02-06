class_name ComponentHealing
extends ComponentUsable


func _init(def: ComponentHealingDefinition) -> void:
	super._init(def)


func use(action: ActionUse) -> bool:
	var amount_recovered: int = action.entity.fighter.heal(power)
	if amount_recovered > 0:
		MessageLog.send_message("You consume the %s and recover %d HP." %
				[entity.entity_name, amount_recovered],
				GameColors.HEALTH_RECOVERED)
		consume(action.entity)
		return true

	MessageLog.send_message("Your health is already full.",
			GameColors.IMPOSSIBLE)
	return false
