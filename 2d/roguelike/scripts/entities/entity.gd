class_name Entity
extends Sprite2D


enum EntityType {CORPSE, ITEM, ACTOR}
enum Behavior {NONE, FRIENDLY, HOSTILE, SCARED, CONFUSED}

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
		inventory = ComponentInventory.new(entity_definition.inventory_capacity)
		add_child(inventory)


func move(move_offset: Vector2i) -> void:
	map_data.unregister_blocker(self)
	grid_position += move_offset
	map_data.register_blocker(self)


func distance(other_grid_position: Vector2i) -> float:
	return (other_grid_position - grid_position).length()


func alive() -> bool:
	return mover != null


func _add_usable(usable_def: ComponentUsableDefinition) -> void:
	if usable_def is ComponentHealingDefinition:
		usable = ComponentHealing.new(usable_def)
	elif usable_def is ComponentLightningDefinition:
		usable = ComponentLightning.new(usable_def)
	elif usable_def is ComponentConfusionDefinition:
		usable = ComponentConfusion.new(usable_def)

	if usable:
		add_child(usable)
