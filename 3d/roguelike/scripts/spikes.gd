class_name Spikes
extends Area3D


const DAMAGE: float = 10.0

@onready var _anim: AnimationPlayer = $Model/AnimationPlayer


func _on_body_entered(_body: Node3D) -> void:
	_anim.play("show-hide")
	if _body is Hero or _body is Enemy:
		_body.take_damage(DAMAGE)
