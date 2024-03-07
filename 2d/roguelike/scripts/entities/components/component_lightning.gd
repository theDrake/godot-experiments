class_name ComponentLightning
extends ComponentUsable


var _max_range: float


func _init(def: ComponentLightningDefinition) -> void:
	super._init(def)
	_max_range = def.max_range


func use(action: ActionUse) -> bool:
	var user: Entity = action.entity
	var map_data: MapData = user.map_data
	var closest_distance: float = _max_range + 1
	var target: Entity
	for actor in map_data.get_actors():
		if actor != user and map_data.get_tile(actor.grid_position).in_view:
			var distance: float = user.distance(actor.grid_position)
			if distance < closest_distance:
				target = actor
				closest_distance = distance
	if target:
		var damage: int = maxi(1, randi_range(power / 2, power) +
				user.fighter.get_spell_potency() -
				target.fighter.get_spell_resistance())
		MessageLog.send_message("Lightning strikes %s for %d damage!" %
				[target.entity_name, damage], GameColors.PLAYER_ATTACK)
		target.fighter.hp -= damage
		consume(user)

		return true

	MessageLog.send_message("No enemy is close enough to strike.",
			GameColors.INVALID)

	return false
