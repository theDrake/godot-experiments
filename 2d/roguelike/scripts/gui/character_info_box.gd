class_name CharacterInfoBox
extends HBoxContainer


var _player: Entity

@onready var _level_label: Label = $LevelLabel
@onready var _attack_label: Label = $AttackLabel
@onready var _defense_label: Label = $DefenseLabel


func _on_player_created(player: Entity) -> void:
	_player = player
	_player.fighter.leveled_up.connect(_on_player_stats_changed)
	_on_player_stats_changed()


func _on_player_stats_changed() -> void:
	_level_label.text = "Level: %d" % _player.fighter.level
	_attack_label.text = "Attack: %d" % _player.fighter.power
	_defense_label.text = "Defense: %d" % _player.fighter.defense
