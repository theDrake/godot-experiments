class_name ComponentFireball
extends ComponentUsable


func _init(def: ComponentFireballDefinition):
	super._init(def)


func use(action: ActionUse) -> bool:
	var target_position: Vector2i = action.target_position
	var map_data: MapData = action.entity.map_data

	if not map_data.get_tile(target_position).in_view:
		MessageLog.send_message("You cannot target what you cannot see.",
				GameColors.IMPOSSIBLE)
		return false

	var targets: Array[Entity] = []
	for actor in map_data.get_actors():
		if actor.distance(target_position) <= radius:
			targets.append(actor)
	if targets.is_empty() or (targets.size() == 1 and targets[0] == \
			map_data.get_player()):
		MessageLog.send_message("No enemies within blast radius.",
				GameColors.INVALID)
		return false

	for target in targets:
		MessageLog.send_message("Flames engulf %s for %d damage!" %
				[target.entity_name, power], GameColors.PLAYER_ATTACK)
		target.fighter.hp -= power
	consume(action.entity)

	return true
