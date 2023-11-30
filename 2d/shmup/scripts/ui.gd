extends MarginContainer
## UI handler for a 2D shmup.
##
## Provides methods to update score count and shield bar.


@onready var _shield_bar := $HBoxContainer/ShieldBar
@onready var _score_counter := $HBoxContainer/ScoreCounter


func update_score(value: int) -> void:
	_score_counter.display_digits(value)


func update_shield(value: float) -> void:
	_shield_bar.value = value
