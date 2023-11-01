extends CanvasLayer
## HUD handler for a simple FPS game.
##
## Updates health display as needed.


func _on_health_updated(health):
	$Health.text = str(health) + "%"
