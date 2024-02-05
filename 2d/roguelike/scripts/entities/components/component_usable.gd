class_name ComponentUsable
extends Component


var ranged: bool = false
var effect_radius: int = 0


func get_action(user: Entity) -> Action:
	return ActionUse.new(user, entity)


func use(action: ActionUse) -> bool:
	return false


func consume(consumer: Entity) -> void:
	consumer.inventory.items.erase(entity)
	entity.queue_free()
