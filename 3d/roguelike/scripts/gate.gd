class_name Gate
extends StaticBody3D


var _closed: bool = true

@onready var _anim: AnimationPlayer = $Model/AnimationPlayer
@onready var _collision_shape: CollisionShape3D = $CollisionShape3D


func open() -> void:
	if _closed:
		_closed = false
		_anim.play("open")
		_collision_shape.disabled = true
