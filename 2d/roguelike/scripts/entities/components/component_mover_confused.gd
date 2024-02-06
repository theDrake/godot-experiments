class_name ComponentMoverConfused
extends ComponentMover


var previous_behavior: ComponentMover
var turns_remaining: int


func _ready() -> void:
	previous_behavior = entity.mover
	entity.mover = self


func _init(turns: int) -> void:
	turns_remaining = turns


func perform() -> bool:
	if turns_remaining <= 0:
		MessageLog.send_message("%s is no longer confused." %
				entity.entity_name, GameColors.STATUS_EFFECT)
		entity.mover = previous_behavior
		queue_free()
		return true
	turns_remaining -= 1
	var direction: Vector2i = InputMain.random_direction()

	return ActionBump.new(entity, direction.x, direction.y).perform()
