extends Label


var score: int


func _ready() -> void:
	_set_score(0)


func _set_score(n: int) -> void:
	score = n
	text = "Score: %s" % score


func _on_enemy_squashed():
	_set_score(score + 1)
