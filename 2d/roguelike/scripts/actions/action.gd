class_name Action
extends RefCounted


var entity: Entity


func _init(e: Entity) -> void:
	entity = e


func perform() -> bool:
	return false
