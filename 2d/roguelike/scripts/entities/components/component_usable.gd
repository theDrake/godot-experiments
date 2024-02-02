class_name ComponentUsable
extends Component


func get_action(user: Entity) -> Action:
	return ActionUse.new(user, entity)


func activate(action: ActionUse) -> bool:
	return false


func consume(consumer: Entity) -> void:
	consumer.inventory.items.erase(entity)
	entity.queue_free()
