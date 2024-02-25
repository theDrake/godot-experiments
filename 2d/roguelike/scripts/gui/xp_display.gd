class_name XPDisplay
extends MarginContainer


@onready var _xp_bar: ProgressBar = $"%XPBar"
@onready var _xp_label: Label = $"%XPLabel"


func _on_player_created(player: Entity) -> void:
	if not is_inside_tree():
		await ready
	player.fighter.xp_changed.connect(_on_player_xp_changed)
	_on_player_xp_changed(player.fighter.xp, player.fighter.xp_for_next_level())


func _on_player_xp_changed(xp: int, max_xp: int) -> void:
	_xp_bar.max_value = max_xp
	_xp_bar.value = xp
	_xp_label.text = "XP: %d/%d" % [xp, max_xp]
