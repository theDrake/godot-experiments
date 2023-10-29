extends ParallaxBackground


const SCROLL_SPEED := 100.0

@export var auto_scroll := false


func _process(delta: float) -> void:
	if auto_scroll:
		scroll_offset.x -= SCROLL_SPEED * delta
