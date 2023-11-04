extends Area2D
## Gem handler for the 'Fox' platformer game.
##
## Provides points when collected, then disappears.


const POINTS_VALUE := 20


func _on_body_entered(body: Node2D) -> void:
	if body.name.begins_with("Play"):
		body.add_points(POINTS_VALUE)
		$AnimatedSprite2D.play("collected")
		await $AnimatedSprite2D.animation_finished
		queue_free()
