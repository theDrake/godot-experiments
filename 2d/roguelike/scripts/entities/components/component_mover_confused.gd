class_name ComponentMoverConfused
extends ComponentMover


var previous_behavior: ComponentMover
var _turns_remaining: int


func _init(turns: int) -> void:
	_turns_remaining = turns


func _ready() -> void:
	previous_behavior = entity.mover
	entity.mover = self


func perform() -> bool:
	if _turns_remaining <= 0:
		MessageLog.send_message("%s is no longer confused!" %
				entity.entity_name, GameColors.STATUS_EFFECT)
		entity.mover = previous_behavior
		queue_free()
		return true
	_turns_remaining -= 1
	var direction: Vector2i = InputMain.random_direction()

	return ActionBump.new(entity, direction.x, direction.y).perform()


func get_save_data() -> Dictionary:
	return {
		"behavior": "ComponentMoverConfused",
		"turns_remaining": _turns_remaining
	}
