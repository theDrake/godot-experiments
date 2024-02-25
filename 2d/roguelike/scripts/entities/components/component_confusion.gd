class_name ComponentConfusion
extends ComponentUsable


func _init(def: ComponentConfusionDefinition) -> void:
	super._init(def)


func use(action: ActionUse) -> bool:
	var user: Entity = action.entity
	var target: Entity = action.get_target_actor()
	if not user.map_data.get_tile(action.target_position).in_view:
		MessageLog.send_message("You cannot target what you cannot see.",
				GameColors.IMPOSSIBLE)
		return false
	elif not target:
		MessageLog.send_message("You must target an enemy.", GameColors.INVALID)
		return false
	elif target == user:
		MessageLog.send_message("You cannot confuse yourself!",
				GameColors.INVALID)
		return false
	MessageLog.send_message("%s is confused." % target.entity_name,
			GameColors.STATUS_EFFECT)
	target.add_child(ComponentMoverConfused.new(power))
	consume(user)

	return true
