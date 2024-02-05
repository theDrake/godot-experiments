class_name ComponentHealing
extends ComponentUsable


var amount: int


func _init(def: ComponentHealingDefinition) -> void:
	amount = def.healing_amount


func use(action: ActionUse) -> bool:
	var amount_recovered: int = action.entity.fighter.heal(amount)
	if amount_recovered > 0:
		MessageLog.send_message("You consume the %s and recover %d HP." %
				[entity.entity_name, amount_recovered],
				GameColors.HEALTH_RECOVERED)
		consume(action.entity)
		return true

	MessageLog.send_message("Your health is already full.",
			GameColors.IMPOSSIBLE)
	return false
