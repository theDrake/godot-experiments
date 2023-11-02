extends Node3D
## Falling platform handler for a 3D platformer.
##
## Causes platform to gradually fall after contact with player.


var falling := false
var gravity := 0.0


func _process(delta):
	scale = scale.lerp(Vector3(1, 1, 1), delta * 10)
	position.y -= gravity * delta
	if position.y < -10:
		queue_free()
	if falling:
		gravity += 0.25


func _on_body_entered(_body):
	if not falling:
		Audio.play("res://sounds/fall.ogg")
		scale = Vector3(1.25, 1, 1.25)
	falling = true
