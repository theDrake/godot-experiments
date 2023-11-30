extends Camera2D
## Camera handler for a 2D shmup.
##
## Provides a camera shake effect.


@export var max_shake := 0.75
@export var max_offset := Vector2(10, 10)
@export var max_roll := 0.2
@export var shake_decay := 0.85

var _shake := 0.0:
	set(n):
		if n < 0:
			_shake = 0.0
		elif n > max_shake:
			_shake = max_shake
		else:
			_shake = n
var _shake_power := 2.5


func _process(delta: float) -> void:
	if _shake:
		_shake = max(_shake - shake_decay * delta, 0)
		_shake_camera()


func increase_shake() -> void:
	_shake += 0.5


func _shake_camera() -> void:
	var amount := pow(_shake, _shake_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)
