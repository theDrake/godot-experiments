class_name ComponentUsable
extends Component


var power: int
var radius: int
var ranged: bool


func _init(def: ComponentUsableDefinition) -> void:
	power = def.power
	radius = def.radius
	ranged = def.ranged


func get_action(user: Entity) -> Action:
	return ActionUse.new(user, entity)


func use(action: ActionUse) -> bool:
	return false


func consume(consumer: Entity) -> void:
	consumer.inventory.items.erase(entity)
	entity.queue_free()
