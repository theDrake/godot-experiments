class_name View
extends Node3D


const DEFAULT_ZOOM: float = 10.0

@export_group("Properties")
@export var target: Node

@export_group("Zoom")
@export var zoom_minimum = 16
@export var zoom_maximum = 4
@export var zoom_speed = 10

@export_group("Rotation")
@export var rotation_speed = 120

var _cam_rotation: Vector3
var _zoom: float = DEFAULT_ZOOM
var _prev_zoom: float = _zoom

@onready var camera = $Camera3D


func _ready():
	_cam_rotation = rotation_degrees # get initial rotation


func _physics_process(delta):
	self.position = self.position.lerp(target.position, delta * 4)
	rotation_degrees = rotation_degrees.lerp(_cam_rotation, delta * 6)
	camera.position = camera.position.lerp(Vector3(0, 0, _zoom), 8 * delta)
	handle_input(delta)


func handle_input(delta):
	# rotate
	var input := Vector3.ZERO
	input.y = Input.get_axis("ui_left", "ui_right")
	input.x = Input.get_axis("ui_up", "ui_down")
	_cam_rotation += input.limit_length(1.0) * rotation_speed * delta
	_cam_rotation.x = clamp(_cam_rotation.x, -80, -10)

	# zoom
	if Input.is_action_just_pressed("zoom_toggle"):
		if is_equal_approx(_zoom, zoom_maximum):
			_zoom = _prev_zoom
		else:
			_prev_zoom = _zoom
			_zoom = zoom_maximum
	else:
		_zoom += Input.get_axis("zoom_in", "zoom_out") * zoom_speed * delta
		_zoom = clamp(_zoom, zoom_maximum, zoom_minimum)
