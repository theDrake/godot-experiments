extends Label
## Score text handler for 'Flap' game.
##
## Updates score text every frame.


func _process(_delta: float) -> void:
	text = "Score: " + str(Global.score)
