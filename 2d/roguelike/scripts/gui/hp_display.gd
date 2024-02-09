class_name HPDisplay
extends MarginContainer


@onready var _hp_bar: ProgressBar = $"%HPBar"
@onready var _hp_label: Label = $"%HPLabel"


func _on_player_created(player: Entity) -> void:
	player.fighter.hp_changed.connect(_on_player_hp_changed)
	_on_player_hp_changed(player.fighter.hp, player.fighter.max_hp)


func _on_player_hp_changed(hp: int, max_hp: int) -> void:
	_hp_bar.max_value = max_hp
	_hp_bar.value = hp
	_hp_label.text = "HP: %d/%d" % [hp, max_hp]
