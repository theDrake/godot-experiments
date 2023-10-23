extends ParallaxBackground
## Environment handler for 'Flap' game.
##
## Ensures pipes are spawned at appropriate times.


#const SCROLL_SPEED := 80

@onready var Pipes := preload("res://scenes/pipes.tscn")


func _ready() -> void:
	spawn_pipes()


#func _process(delta: float) -> void:
#	scroll_base_offset.x -= SCROLL_SPEED * delta


func spawn_pipes() -> void:
	add_child(Pipes.instantiate())


func _on_timer_timeout() -> void:
	spawn_pipes()
