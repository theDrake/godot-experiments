class_name ComponentConfusion
extends ComponentUsable


var _num_turns: int


func _init(def: ComponentConfusionDefinition) -> void:
	_num_turns = def.num_turns
	ranged = true


func use(action: ActionUse) -> bool:
	var user: Entity = action.entity
	var target: Entity = action.get_target_actor()
	if not user.map_data.get_tile(action.target_position).in_view:
		MessageLog.send_message("You cannot target what you cannot see.",
				GameColors.IMPOSSIBLE)
		return false
	elif not target:
		MessageLog.send_message("You must target an enemy.",
				GameColors.IMPOSSIBLE)
		return false
	elif target == user:
		MessageLog.send_message("You cannot confuse yourself!",
				GameColors.IMPOSSIBLE)
		return false
	MessageLog.send_message("%s is confused!" % target.entity_name,
			GameColors.STATUS_EFFECT)
	target.add_child(ComponentMoverConfused.new(_num_turns))
	consume(user)

	return true
