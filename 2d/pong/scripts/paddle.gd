extends Area2D


const SPEED := 200.0

var _ball_dir: float
var _up: String
var _down: String

@onready var _screen_height := get_viewport_rect().size.y


func _ready() -> void:
	var n := String(name).to_lower() # 'left' or 'right'
	_up = n + "_move_up"
	_down = n + "_move_down"
	if n == "left":
		_ball_dir = 1
	else:
		_ball_dir = -1


func _process(delta: float) -> void:
	var input := Input.get_action_strength(_down) - \
			Input.get_action_strength(_up)
	position.y = clamp(position.y + input * SPEED * delta, 16,
			_screen_height - 16)


func _on_area_entered(other: Area2D) -> void:
	if other.name == "Ball":
		other.direction = Vector2(_ball_dir, randf() * 2 - 1).normalized()
