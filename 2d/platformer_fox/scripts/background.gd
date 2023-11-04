extends ParallaxBackground
## Background handler for the 'Fox' platformer game.
##
## Provides option to automatically scroll the background (e.g., for main menu).


const SCROLL_SPEED := 100.0

@export var auto_scroll := false


func _process(delta: float) -> void:
	if auto_scroll:
		scroll_offset.x -= SCROLL_SPEED * delta
