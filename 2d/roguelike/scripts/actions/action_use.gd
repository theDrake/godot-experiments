class_name ActionUse
extends Action


var item: Entity
var target_position: Vector2i


func _init(user: Entity, item: Entity, target = null) -> void:
	super._init(user)
	self.item = item
	if not target is Vector2i:
		target = user.grid_position
	target_position = target


func perform() -> bool:
	return item and item.usable.activate(self)


func get_target_actor() -> Entity:
	return get_map_data().get_actor_at(target_position)
