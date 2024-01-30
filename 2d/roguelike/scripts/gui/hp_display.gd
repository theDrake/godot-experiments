class_name HPDisplay
extends MarginContainer


@onready var hp_bar: ProgressBar = $"%HPBar"
@onready var hp_label: Label = $"%HPLabel"


func initialize(player: Entity) -> void:
	await ready
	player.fighter_type.hp_changed.connect(player_hp_changed)
	player_hp_changed(player.fighter_type.hp, player.fighter_type.max_hp)


func player_hp_changed(hp: int, max_hp: int) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	hp_label.text = "HP: %d/%d" % [hp, max_hp]
