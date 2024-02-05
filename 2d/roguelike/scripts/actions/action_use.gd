class_name ActionUse
extends Action


var target_position: Vector2i

var _item: Entity


func _init(user: Entity, item: Entity, target = null) -> void:
	super._init(user)
	_item = item
	if not target is Vector2i:
		target = user.grid_position
	target_position = target


func perform() -> bool:
	return _item and _item.usable.use(self)


func get_target_actor() -> Entity:
	return get_map_data().get_actor_at(target_position)
