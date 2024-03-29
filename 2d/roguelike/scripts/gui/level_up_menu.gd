class_name LevelUpMenu
extends CanvasLayer


signal level_up_completed

var _player: Entity
@onready var _health_upgrade_button: Button = $"%HealthUpgradeButton"
@onready var _power_upgrade_button: Button = $"%PowerUpgradeButton"
@onready var _defense_upgrade_button: Button = $"%DefenseUpgradeButton"
@onready var _intellect_upgrade_button: Button = $"%IntellectUpgradeButton"


func init_buttons(player: Entity) -> void:
	_player = player
	_health_upgrade_button.text = "(1) Constitution (+%d max. HP)" % \
			ComponentFighter.DEFAULT_MAX_HP_BOOST
	_power_upgrade_button.text = "(2) Strength (+%d physical attack)" % \
			ComponentFighter.DEFAULT_POWER_BOOST
	_defense_upgrade_button.text = "(3) Agility (+%d physical defense)" % \
			ComponentFighter.DEFAULT_DEFENSE_BOOST
	_intellect_upgrade_button.text = \
			"(4) Intellect (+%d spell potency/resistance)" % \
			ComponentFighter.DEFAULT_INTELLECT_BOOST
	_health_upgrade_button.grab_focus()


func _on_health_upgrade_button_pressed() -> void:
	_player.fighter.increase_max_hp()
	queue_free()
	level_up_completed.emit()


func _on_power_upgrade_button_pressed() -> void:
	_player.fighter.increase_power()
	queue_free()
	level_up_completed.emit()


func _on_defense_upgrade_button_pressed() -> void:
	_player.fighter.increase_defense()
	queue_free()
	level_up_completed.emit()


func _on_intellect_upgrade_button_pressed() -> void:
	_player.fighter.increase_intellect()
	queue_free()
	level_up_completed.emit()
