extends AnimatedSprite3D
## Impact effect handler for a simple FPS game.
##
## Removes impact effect as soon as the animation completes.


func _on_animation_finished():
	queue_free()
