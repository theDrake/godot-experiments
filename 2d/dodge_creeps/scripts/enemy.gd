class_name Enemy
extends RigidBody2D


const MIN_VELOCITY := 150.0
const MAX_VELOCITY := 250.0


func _ready() -> void:
	var animations := $AnimatedSprite2D.sprite_frames.get_animation_names() as \
			PackedStringArray
	$AnimatedSprite2D.play(animations[randi() % animations.size()])


func _on_screen_exited() -> void:
	queue_free()
