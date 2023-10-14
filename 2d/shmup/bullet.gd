extends Area2D
## Player bullet handler for a 2D shmup.
##
## Bullets move up, kill enemies, and disappear on exit.


@export var speed = -250


func start(pos):
	position = pos


func _process(delta):
	position.y += speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area.is_in_group("enemies"):
		area.explode()
		queue_free()
