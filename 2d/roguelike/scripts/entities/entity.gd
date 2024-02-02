class_name Entity
extends Sprite2D


enum Personality {NONE, FRIENDLY, HOSTILE, SCARED}
enum EntityType {CORPSE, ITEM, ACTOR}

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


func _init(data: MapData, spawn_point: Vector2i,
		entity_definition: EntityDefinition) -> void:
	centered = false
	map_data = data
	grid_position = spawn_point
	set_entity_type(entity_definition)


func set_entity_type(entity_definition: EntityDefinition) -> void:
	_def = entity_definition
	type = _def.type
	entity_name = _def.name
	blocks_movement = _def.blocks_movement
	texture = _def.texture
	#modulate = _def.color
	mover = null
	match _def.personality:
		Personality.HOSTILE:
			mover = ComponentMoverHostile.new()
			add_child(mover)
	fighter = null
	if _def.fighter_def:
		fighter = ComponentFighter.new(_def.fighter_def)
		add_child(fighter)
	if _def.usable_def:
		if _def.usable_def is ComponentUsableHealingDefinition:
			usable = ComponentUsableHealing.new(entity_definition.usable_def)
			add_child(usable)
	if _def.inventory_capacity > 0:
		inventory = ComponentInventory.new(entity_definition.inventory_capacity)
		add_child(inventory)

func move(move_offset: Vector2i) -> void:
	map_data.unregister_blocker(self)
	grid_position += move_offset
	map_data.register_blocker(self)


func alive() -> bool:
	return mover != null
