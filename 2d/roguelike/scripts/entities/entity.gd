class_name Entity
extends Sprite2D


enum EntityType {CORPSE, ITEM, ACTOR}
enum Behavior {NONE, FRIENDLY, HOSTILE, SCARED, CONFUSED}

const ENTITY_DEFINITIONS = {
	"Player": "res://resources/player/player.tres",
	"Bat": "res://resources/enemies/bat.tres",
	"Beetle": "res://resources/enemies/beetle.tres",
	"Cyclops": "res://resources/enemies/cyclops.tres",
	"Demon": "res://resources/enemies/demon.tres",
	"Djinn": "res://resources/enemies/djinn.tres",
	"Ghost": "res://resources/enemies/ghost.tres",
	"Ghoul": "res://resources/enemies/ghoul.tres",
	"Goblin": "res://resources/enemies/goblin.tres",
	"Hobgoblin": "res://resources/enemies/hobgoblin.tres",
	"Imp": "res://resources/enemies/imp.tres",
	"Ogre": "res://resources/enemies/ogre.tres",
	"Orc": "res://resources/enemies/orc.tres",
	"Scorpion": "res://resources/enemies/scorpion.tres",
	"Skeleton": "res://resources/enemies/skeleton.tres",
	"Slime": "res://resources/enemies/slime.tres",
	"Snake": "res://resources/enemies/snake.tres",
	"Sorcerer": "res://resources/enemies/sorcerer.tres",
	"Spider": "res://resources/enemies/spider.tres",
	"Troll": "res://resources/enemies/troll.tres",
	"Potion of Healing": "res://resources/usable_items/potion_healing.tres",
	"Scroll of Lightning": "res://resources/usable_items/scroll_lightning.tres",
	"Scroll of Fireball": "res://resources/usable_items/scroll_fireball.tres",
	"Scroll of Confusion": "res://resources/usable_items/scroll_confusion.tres",
	"Iron Dagger": "res://resources/equipment/dagger_iron.tres",
	"Steel Dagger": "res://resources/equipment/dagger_steel.tres",
	"Elven Dagger": "res://resources/equipment/dagger_elven.tres",
	"Dwarven Dagger": "res://resources/equipment/dagger_dwarven.tres",
	"Iron Sword": "res://resources/equipment/sword_iron.tres",
	"Steel Sword": "res://resources/equipment/sword_steel.tres",
	"Elven Sword": "res://resources/equipment/sword_elven.tres",
	"Dwarven Sword": "res://resources/equipment/sword_dwarven.tres",
	"Iron Axe": "res://resources/equipment/axe_iron.tres",
	"Steel Axe": "res://resources/equipment/axe_steel.tres",
	"Elven Axe": "res://resources/equipment/axe_elven.tres",
	"Dwarven Axe": "res://resources/equipment/axe_dwarven.tres",
	"Iron Helm": "res://resources/equipment/helm_iron.tres",
	"Steel Helm": "res://resources/equipment/helm_steel.tres",
	"Elven Helm": "res://resources/equipment/helm_elven.tres",
	"Dwarven Helm": "res://resources/equipment/helm_dwarven.tres",
	"Cloak": "res://resources/equipment/armor_cloak.tres",
	"Leather Armor": "res://resources/equipment/armor_leather.tres",
	"Iron Armor": "res://resources/equipment/armor_iron.tres",
	"Steel Armor": "res://resources/equipment/armor_steel.tres",
	"Elven Armor": "res://resources/equipment/armor_elven.tres",
	"Dwarven Armor": "res://resources/equipment/armor_dwarven.tres",
	"Leather Gloves": "res://resources/equipment/gauntlets_leather.tres",
	"Iron Gauntlets": "res://resources/equipment/gauntlets_iron.tres",
	"Steel Gauntlets": "res://resources/equipment/gauntlets_steel.tres",
	"Elven Gauntlets": "res://resources/equipment/gauntlets_elven.tres",
	"Dwarven Gauntlets": "res://resources/equipment/gauntlets_dwarven.tres",
	"Leather Boots": "res://resources/equipment/boots_leather.tres",
	"Iron Boots": "res://resources/equipment/boots_iron.tres",
	"Steel Boots": "res://resources/equipment/boots_steel.tres",
	"Elven Boots": "res://resources/equipment/boots_elven.tres",
	"Dwarven Boots": "res://resources/equipment/boots_dwarven.tres",
	"Wooden Shield": "res://resources/equipment/shield_wooden.tres",
	"Iron Shield": "res://resources/equipment/shield_iron.tres",
	"Steel Shield": "res://resources/equipment/shield_steel.tres",
	"Elven Shield": "res://resources/equipment/shield_elven.tres",
	"Dwarven Shield": "res://resources/equipment/shield_dwarven.tres",
}
const CORPSE_TEXT := "Remains of "

var type: EntityType:
	set(value):
		type = value
		z_index = value
var entity_name: String
var grid_position: Vector2i:
	set(value):
		grid_position = value
		position = Grid.grid_to_world(value)
var map_data: MapData
var fighter: ComponentFighter
var mover: ComponentMover
var usable: ComponentUsable
var equipment: ComponentEquipment
var inventory: ComponentInventory
var blocks_movement: bool
var is_player: bool = false

var _def: EntityDefinition


func _init(data: MapData, spawn_point: Vector2i, entity_str: String) -> void:
	centered = false
	map_data = data
	grid_position = spawn_point
	if entity_str:
		init_entity(entity_str)


func init_entity(entity_str: String) -> void:
	if entity_str.begins_with(CORPSE_TEXT):
		entity_str = entity_str.erase(0, CORPSE_TEXT.length())
	entity_name = entity_str
	is_player = entity_name == "Player"
	_def = load(ENTITY_DEFINITIONS[entity_name])
	type = _def.type
	blocks_movement = _def.blocks_movement
	texture = _def.texture
	#modulate = _def.color
	mover = null
	match _def.behavior:
		Behavior.HOSTILE:
			mover = ComponentMoverHostile.new()
			add_child(mover)
	fighter = null
	if _def.fighter_def:
		fighter = ComponentFighter.new(_def.fighter_def)
		add_child(fighter)
	_add_item(_def.item_def)
	if _def.inventory_capacity > 0:
		inventory = ComponentInventory.new(_def.inventory_capacity)
		add_child(inventory)


func move(move_offset: Vector2i) -> void:
	map_data.unregister_blocker(self)
	grid_position += move_offset
	map_data.register_blocker(self)


func distance(other_grid_position: Vector2i) -> int:
	var vector: Vector2i = other_grid_position - grid_position
	return maxi(abs(vector.x), abs(vector.y))


func alive() -> bool:
	return mover != null


func get_save_data() -> Dictionary:
	var save_data: Dictionary = {
		"x": grid_position.x,
		"y": grid_position.y,
		"entity_name": entity_name,
	}
	if fighter:
		save_data["fighter"] = fighter.get_save_data()
	if mover:
		save_data["mover"] = mover.get_save_data()
	if inventory:
		save_data["inventory"] = inventory.get_save_data()
	if equipment:
		save_data["equipped"] = equipment.equipped

	return save_data


func restore(save_data: Dictionary) -> void:
	grid_position = Vector2i(save_data["x"], save_data["y"])
	init_entity(save_data["entity_name"])
	if equipment and save_data.has("equipped"):
		equipment.equipped = save_data["equipped"]
	if fighter and save_data.has("fighter"):
		fighter.restore(save_data["fighter"])
	if mover and save_data.has("mover"):
		var mover_data: Dictionary = save_data["mover"]
		if mover_data["behavior"] == "ComponentMoverConfused":
			add_child(ComponentMoverConfused.new(mover_data["turns_remaining"]))
	if inventory and save_data.has("inventory"):
		inventory.restore(save_data["inventory"])
		for item in inventory.items:
			if fighter and item.equipment and item.equipment.equipped:
				fighter.equipment_slots[item.equipment.type].append(item)


func _add_item(item_def: ComponentItemDefinition) -> void:
	if item_def is ComponentHealingDefinition:
		usable = ComponentHealing.new(item_def)
	elif item_def is ComponentLightningDefinition:
		usable = ComponentLightning.new(item_def)
	elif item_def is ComponentFireballDefinition:
		usable = ComponentFireball.new(item_def)
	elif item_def is ComponentConfusionDefinition:
		usable = ComponentConfusion.new(item_def)
	elif item_def is ComponentEquipmentDefinition:
		equipment = ComponentEquipment.new(item_def)

	if usable:
		usable.entity = self
		add_child(usable)
	elif equipment:
		equipment.entity = self
		add_child(equipment)
