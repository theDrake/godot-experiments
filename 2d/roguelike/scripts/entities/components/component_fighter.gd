class_name ComponentFighter
extends Component


signal hp_changed(hp, max_hp)
signal xp_changed(xp, max_xp)
signal equipment_changed
signal level_up_required
signal leveled_up

const DEFAULT_MAX_HP_BOOST: int = 5
const DEFAULT_POWER_BOOST: int = 1
const DEFAULT_DEFENSE_BOOST: int = 1
const PLAYER_TEXTURES = {
	"default": preload("res://resources/player/default_texture.tres"),
	"onehanded": preload("res://resources/player/sword_shield_texture.tres"),
	"dual-onehanded": preload(
			"res://resources/player/sword_sword_texture.tres"),
	"twohanded": preload("res://resources/player/spear_texture.tres"),
	"cloaked": preload("res://resources/player/cloak_texture.tres"),
	"cloaked-twohanded": preload(
			"res://resources/player/cloak_staff_texture.tres"),
	"helmeted": preload("res://resources/player/helm_texture.tres"),
	"helmeted-onehanded": preload(
			"res://resources/player/helm_sword_shield_texture.tres"),
}

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
var equipment_slots: Array[Array] = []
var death_texture: Texture
#var death_color: Color
var xp: int
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
	for type in ComponentEquipment.Type:
		equipment_slots.append([])


func _ready() -> void:
	if entity.is_player:
		equipment_changed.connect(update_texture)


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
			death_message = "Alas, you have perished..."
			death_message_color = GameColors.PLAYER_DEATH
			SignalBus.player_died.emit()
		else:
			death_message = "%s dies!" % entity.entity_name
			death_message_color = GameColors.ENEMY_DEATH
		MessageLog.send_message(death_message, death_message_color)
		if not entity.is_player:
			entity.map_data.get_player().fighter.gain_xp(xp)

	var tile_type: Tile.TileType = entity.map_data.get_tile(
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
	entity.map_data.unregister_blocker(entity)
	entity.type = Entity.EntityType.CORPSE


func equip(item: Entity, verbose: bool = false) -> bool:
	if not item or not item.equipment:
		return false
	elif item.equipment.equipped:
		return unequip(item, verbose)

	var type: ComponentEquipment.Type = item.equipment.type
	var current_items: Array = equipment_slots[type]
	if type == ComponentEquipment.Type.TWO_HANDED:
		if current_items.size() > 0:
			unequip(current_items[0], verbose)
		while equipment_slots[ComponentEquipment.Type.ONE_HANDED].size() > 0:
			unequip(equipment_slots[ComponentEquipment.Type.ONE_HANDED][0],
					verbose)
	elif type == ComponentEquipment.Type.ONE_HANDED:
		if equipment_slots[ComponentEquipment.Type.TWO_HANDED].size() > 0:
			unequip(equipment_slots[ComponentEquipment.Type.TWO_HANDED][0],
					verbose)
		elif current_items.size() == 2: # hands are full
			if _is_shield(item):
				_unequip_weakest_shield()
			else:
				_unequip_weakest_weapon()
	elif current_items.size() >= ComponentEquipment.MAX[type]:
		unequip(current_items.back(), verbose)
	equipment_slots[type].append(item)
	power += item.equipment.power_bonus
	defense += item.equipment.defense_bonus
	item.equipment.equipped = true
	if verbose:
		MessageLog.send_message("You equip %s." % item.entity_name,
				GameColors.EQUIPMENT)
	equipment_changed.emit()

	return true


func unequip(item: Entity, verbose: bool = false) -> bool:
	if item and item.equipment and item.equipment.equipped:
		var type: ComponentEquipment.Type = item.equipment.type
		for i in equipment_slots[type].size():
			if equipment_slots[type][i] == item:
				equipment_slots[type].remove_at(i)
				power -= item.equipment.power_bonus
				defense -= item.equipment.defense_bonus
				item.equipment.equipped = false
				if verbose:
					MessageLog.send_message("You unequip %s." %
							item.entity_name, GameColors.EQUIPMENT)
				equipment_changed.emit()
				return true

	return false


func gain_xp(amount: int) -> void:
	xp += amount
	xp_changed.emit(xp, xp_for_next_level())
	if amount <= 0 or level_up_base == 0:
		return
	MessageLog.send_message("You earn %d experience." % amount,
			GameColors.XP_EARNED)
	if xp >= xp_for_next_level():
		MessageLog.send_message("You advance to level %d!" % (level + 1),
				GameColors.LEVEL_UP)
		level_up_required.emit()


func level_up() -> void:
	xp -= xp_for_next_level()
	level += 1
	leveled_up.emit()


func xp_for_next_level() -> int:
	return level_up_base + level * level_up_factor


func increase_max_hp(amount: int = DEFAULT_MAX_HP_BOOST) -> void:
	max_hp += amount
	hp += amount
	MessageLog.send_message("You feel invigorated!", GameColors.STATUS_EFFECT)
	level_up()


func increase_power(amount: int = DEFAULT_POWER_BOOST) -> void:
	power += amount
	MessageLog.send_message("You feel stronger!", GameColors.STATUS_EFFECT)
	level_up()


func increase_defense(amount: int = DEFAULT_DEFENSE_BOOST) -> void:
	defense += amount
	MessageLog.send_message("You feel lighter on your feet!",
			GameColors.STATUS_EFFECT)
	level_up()


func update_texture() -> void:
	if not entity or not entity.is_player:
		return

	if _dual_wielding():
		entity.texture = PLAYER_TEXTURES["dual-onehanded"]
	elif _get_equipment(ComponentEquipment.Type.BODY) and \
			_get_equipment(ComponentEquipment.Type.BODY).entity_name.contains(
			"Cloak"):
		if _get_equipment(ComponentEquipment.Type.TWO_HANDED):
			entity.texture = PLAYER_TEXTURES["cloaked-twohanded"]
		else:
			entity.texture = PLAYER_TEXTURES["cloaked"]
	elif _get_equipment(ComponentEquipment.Type.TWO_HANDED):
		entity.texture = PLAYER_TEXTURES["twohanded"]
	elif _get_equipment(ComponentEquipment.Type.HEAD) and \
			_get_equipment(ComponentEquipment.Type.HEAD).entity_name.contains(
			"Helm"):
		if _get_equipment(ComponentEquipment.Type.ONE_HANDED):
			entity.texture = PLAYER_TEXTURES["helmeted-onehanded"]
		else:
			entity.texture = PLAYER_TEXTURES["helmeted"]
	elif _get_equipment(ComponentEquipment.Type.ONE_HANDED):
		entity.texture = PLAYER_TEXTURES["onehanded"]
	else:
		entity.texture = PLAYER_TEXTURES["default"]


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
	equipment_slots = []
	for type in ComponentEquipment.Type:
		equipment_slots.append([])


func _get_equipment(type: ComponentEquipment.Type) -> Entity:
	if equipment_slots[type].size() > 0:
		return equipment_slots[type][0]

	return null


func _dual_wielding() -> bool:
	var type := ComponentEquipment.Type.ONE_HANDED
	return equipment_slots[type].size() > 1 and \
			_is_weapon(equipment_slots[type][0]) and \
			_is_weapon(equipment_slots[type][1])


func _is_shield(item: Entity) -> bool:
	return item.entity_name.contains("Shield")


func _is_weapon(item: Entity) -> bool:
	return not _is_shield(item) # for now, this is enough


func _unequip_weakest_shield(verbose: bool = true) -> bool:
	var type := ComponentEquipment.Type.ONE_HANDED
	if equipment_slots[type].size() < 2:
		return false
	elif _is_weapon(equipment_slots[type][0]) and \
			_is_weapon(equipment_slots[type][1]):
		return _unequip_weakest_weapon(verbose)
	elif _is_shield(equipment_slots[type][0]) and (
			_is_weapon(equipment_slots[type][1]) or
			equipment_slots[type][0].equipment.defense_bonus <
			equipment_slots[type][1].equipment.defense_bonus):
		return unequip(equipment_slots[type][0], verbose)
	else:
		return unequip(equipment_slots[type][1], verbose)


func _unequip_weakest_weapon(verbose: bool = true) -> bool:
	var type := ComponentEquipment.Type.ONE_HANDED
	if equipment_slots[type].size() < 2:
		return false
	elif _is_shield(equipment_slots[type][0]) and \
			_is_shield(equipment_slots[type][1]):
		return _unequip_weakest_shield(verbose)
	elif _is_weapon(equipment_slots[type][0]) and (
			_is_shield(equipment_slots[type][1]) or
			equipment_slots[type][0].equipment.power_bonus <
			equipment_slots[type][1].equipment.power_bonus):
		return unequip(equipment_slots[type][0], verbose)
	else:
		return unequip(equipment_slots[type][1], verbose)
