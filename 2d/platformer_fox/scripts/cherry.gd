extends Area2D
## Cherry handler for the 'Fox' platformer game.
##
## Provides health when collected, then disappears.


const HEALTH_MODIFIER := 5


func _on_body_entered(body: Node2D) -> void:
	if body.name.begins_with("Play"):
		body.add_health(HEALTH_MODIFIER)
		$AnimatedSprite2D.play("collected")
		await $AnimatedSprite2D.animation_finished
		queue_free()
