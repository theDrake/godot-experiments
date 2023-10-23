extends RigidBody2D
## Player handler for 'Flap' game.
##
## Causes bird to fly upwards when any key or mouse button is pressed and to
## disappear upon impact with a pipe or the ground.


const UPWARD_SPEED := 250
const ROTATION_SPEED := 5


func _input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		set_linear_velocity(Vector2(0, -UPWARD_SPEED))
		set_angular_velocity(-ROTATION_SPEED)
		$AnimatedSprite2D.play("fly")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		queue_free()
