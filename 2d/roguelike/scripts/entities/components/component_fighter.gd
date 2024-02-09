class_name ComponentFighter
extends Component


signal hp_changed(hp, max_hp)

var max_hp: int
var hp: int:
	set(value):
		hp = clampi(value, 0, max_hp)
		hp_changed.emit(hp, max_hp)
		if hp <= 0:
			var die_silently: bool = false
			if not is_inside_tree():
				die_silently = true
				await ready
			die(die_silently)
var defense: int
var power: int
var death_texture: Texture
#var death_color: Color


func _init(definition: ComponentFighterDefinition) -> void:
	max_hp = definition.max_hp
	hp = definition.max_hp
	defense = definition.defense
	power = definition.power
	death_texture = definition.death_texture
	#death_color = definition.death_color


func heal(amount: int) -> int:
	if hp == max_hp or amount < 0:
		return 0
	amount = max(amount, amount + hp - max_hp)
	hp += amount
	return amount


func take_damage(amount: int) -> void:
	hp -= amount


func die(silently: bool = false) -> void:
	if not silently:
		var death_message: String
		var death_message_color: Color
		if entity.is_player:
			death_message = "Alas, you have perished!"
			death_message_color = GameColors.PLAYER_DEATH
			SignalBus.player_died.emit()
		else:
			death_message = "%s is dead!" % entity.entity_name
			death_message_color = GameColors.ENEMY_DEATH
		MessageLog.send_message(death_message, death_message_color)

	entity.texture = death_texture
	#entity.modulate = death_color
	entity.mover.queue_free()
	entity.mover = null
	entity.entity_name = Entity.CORPSE_TEXT + entity.entity_name
	entity.blocks_movement = false
	get_map_data().unregister_blocker(entity)
	entity.type = Entity.EntityType.CORPSE


func get_save_data() -> Dictionary:
	return {
		"max_hp": max_hp,
		"hp": hp,
		"defense": defense,
		"power": power,
	}


func restore(save_data: Dictionary) -> void:
	max_hp = save_data["max_hp"]
	hp = save_data["hp"]
	defense = save_data["defense"]
	power = save_data["power"]
