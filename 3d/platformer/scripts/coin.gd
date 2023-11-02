extends Area3D
## Coin handler for a 3D platformer.
##
## Coins rotate and bob up and down. After collection, they disappear.


var time := 0.0
var grabbed := false


func _on_body_entered(body):
	if body.has_method("collect_coin") and not grabbed:
		grabbed = true
		body.collect_coin()
		Audio.play("res://sounds/coin.ogg")

		# make invisible
		$Mesh.queue_free()
		$Particles.emitting = false


func _process(delta):
	rotate_y(2 * delta)
	position.y += cos(time * 5) * delta
	time += delta
