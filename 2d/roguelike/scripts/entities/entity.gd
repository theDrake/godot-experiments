class_name Entity
extends Sprite2D


enum EntityType {CORPSE, ITEM, ACTOR}
enum Behavior {NONE, FRIENDLY, HOSTILE, SCARED, CONFUSED}

const ENTITY_DEFINITIONS = {
	"Player": "res://resources/entity_player.tres",
	"Orc": "res://resources/entity_orc.tres",
	"Troll": "res://resources/entity_troll.tres",
	"Potion of Healing": "res://resources/entity_potion_of_healing.tres",
	"Scroll of Lightning": "res://resources/entity_scroll_of_lightning.tres",
	"Scroll of Fireball": "res://resources/entity_scroll_of_fireball.tres",
	"Scroll of Confusion": "res://resources/entity_scroll_of_confusion.tres",
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
	_add_usable(_def.usable_def)
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

	return save_data


func restore(save_data: Dictionary) -> void:
	grid_position = Vector2i(save_data["x"], save_data["y"])
	init_entity(save_data["entity_name"])
	if fighter and save_data.has("fighter"):
		fighter.restore(save_data["fighter"])
	if mover and save_data.has("mover"):
		var mover_data: Dictionary = save_data["mover"]
		if mover_data["behavior"] == "ComponentMoverConfused":
			add_child(ComponentMoverConfused.new(mover_data["turns_remaining"]))
	if inventory and save_data.has("inventory"):
		inventory.restore(save_data["inventory"])


func _add_usable(usable_def: ComponentUsableDefinition) -> void:
	if usable_def is ComponentHealingDefinition:
		usable = ComponentHealing.new(usable_def)
	elif usable_def is ComponentLightningDefinition:
		usable = ComponentLightning.new(usable_def)
	elif usable_def is ComponentFireballDefinition:
		usable = ComponentFireball.new(usable_def)
	elif usable_def is ComponentConfusionDefinition:
		usable = ComponentConfusion.new(usable_def)

	if usable:
		usable.entity = self
		add_child(usable)
