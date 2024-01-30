class_name InputMain
extends InputBase


const DIRECTIONS = {
	"move_up": Vector2i.UP,
	"move_down": Vector2i.DOWN,
	"move_left": Vector2i.LEFT,
	"move_right": Vector2i.RIGHT,
	"move_up_left": Vector2i.UP + Vector2i.LEFT,
	"move_up_right": Vector2i.UP + Vector2i.RIGHT,
	"move_down_left": Vector2i.DOWN + Vector2i.LEFT,
	"move_down_right": Vector2i.DOWN + Vector2i.RIGHT,
}


func get_action(player: Entity) -> Action:
	if Input.is_action_just_pressed("quit"):
		return ActionQuit.new(player)
	elif Input.is_action_just_pressed("wait"):
		return ActionWait.new(player)
	elif Input.is_action_just_pressed("view_history"):
		SignalBus.toggle_view_history.emit()
	for direction in DIRECTIONS:
		if Input.is_action_just_pressed(direction):
			var offset: Vector2i = DIRECTIONS[direction]
			return ActionBump.new(player, offset.x, offset.y)

	return null
