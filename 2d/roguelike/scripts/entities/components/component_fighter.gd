class_name ComponentFighter
extends Component


signal hp_changed(hp, max_hp)
signal xp_changed(xp, max_xp)
signal level_up_required
signal leveled_up

const DEFAULT_MAX_HP_BOOST: int = 5
const DEFAULT_POWER_BOOST: int = 1
const DEFAULT_DEFENSE_BOOST: int = 1

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
var xp: int:
	set(value):
		var diff: int = value - xp
		xp = value
		xp_changed.emit(xp, xp_for_next_level())
		if diff <= 0 or level_up_base == 0:
			return
		MessageLog.send_message("%d experience earned." % diff,
				GameColors.XP_EARNED)
		if xp >= xp_for_next_level():
			MessageLog.send_message("You advance to level %d!" % (level + 1),
					GameColors.LEVEL_UP)
			level_up_required.emit()
var level: int
var level_up_base: int
var level_up_factor: int


func _init(def: ComponentFighterDefinition) -> void:
	max_hp = def.max_hp
	hp = def.max_hp
	defense = def.defense
	power = def.power
	death_texture = def.death_texture
	#death_color = def.death_color
	xp = def.xp
	level = def.level
	level_up_base = def.level_up_base
	level_up_factor = def.level_up_factor


func heal(amount: int) -> int:
	if hp == max_hp or amount < 0:
		return 0

	amount = mini(amount, max_hp - hp)
	hp += amount

	return amount


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
		if not entity.is_player:
			get_map_data().get_player().fighter.xp += xp

	var tile_type: Tile.TileType = get_map_data().get_tile(
			entity.grid_position).type
	if not entity.is_player and (tile_type == Tile.TileType.STAIRS_UP or
			tile_type == Tile.TileType.STAIRS_DOWN):
		entity.texture = null
	else:
		entity.texture = death_texture
	#entity.modulate = death_color
	entity.mover.queue_free()
	entity.mover = null
	entity.entity_name = Entity.CORPSE_TEXT + entity.entity_name
	entity.blocks_movement = false
	get_map_data().unregister_blocker(entity)
	entity.type = Entity.EntityType.CORPSE


func level_up() -> void:
	xp -= xp_for_next_level()
	level += 1
	leveled_up.emit()


func xp_for_next_level() -> int:
	return level_up_base + level * level_up_factor


func increase_max_hp(amount: int = DEFAULT_MAX_HP_BOOST) -> void:
	max_hp += amount
	hp += amount
	MessageLog.send_message("Health increased!", GameColors.STATUS_EFFECT)
	level_up()


func increase_power(amount: int = DEFAULT_POWER_BOOST) -> void:
	power += amount
	MessageLog.send_message("Power increased!", GameColors.STATUS_EFFECT)
	level_up()


func increase_defense(amount: int = DEFAULT_DEFENSE_BOOST) -> void:
	defense += amount
	MessageLog.send_message("Defense increased!", GameColors.STATUS_EFFECT)
	level_up()


func get_save_data() -> Dictionary:
	return {
		"max_hp": max_hp,
		"hp": hp,
		"defense": defense,
		"power": power,
		"xp": xp,
		"level": level,
		"level_up_base": level_up_base,
		"level_up_factor": level_up_factor,
	}


func restore(save_data: Dictionary) -> void:
	max_hp = save_data["max_hp"]
	hp = save_data["hp"]
	defense = save_data["defense"]
	power = save_data["power"]
	xp = save_data["xp"]
	level = save_data["level"]
	level_up_base = save_data["level_up_base"]
	level_up_factor = save_data["level_up_factor"]
