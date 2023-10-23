extends RigidBody2D
## Player handler for 'Flap' game.
##
## Causes bird to fly upwards when a left-click is detected.


const UPWARD_SPEED := 250
const ROTATION_SPEED := 5


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			set_linear_velocity(Vector2(0, -UPWARD_SPEED))
			set_angular_velocity(-ROTATION_SPEED)
			$AnimatedSprite2D.play("fly")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		queue_free()
