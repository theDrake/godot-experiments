class_name ComponentLightning
extends ComponentUsable


var damage: int
var max_range: float


func _init(definition: ComponentLightningDefinition) -> void:
	damage = definition.damage
	max_range = definition.max_range


func use(action: ActionUse) -> bool:
	var user: Entity = action.entity
	var map_data: MapData = user.map_data
	var closest_distance: float = max_range + 1
	var target: Entity
	for actor in map_data.get_actors():
		if actor != user and map_data.get_tile(actor.grid_position).in_view:
			var distance: float = user.distance(actor.grid_position)
			if distance < closest_distance:
				target = actor
				closest_distance = distance
	if target:
		MessageLog.send_message("Lightning strikes %s for %d damage!" %
				[target.entity_name, damage], Color.WHITE)
		target.fighter.take_damage(damage)
		consume(user)
		return true

	MessageLog.send_message("No enemy is close enough to strike.",
			GameColors.IMPOSSIBLE)
	return false
