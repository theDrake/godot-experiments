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
var fighter_type: ComponentFighter
var mover_type: ComponentMover
var blocks_movement: bool

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
	mover_type = null
	match _def.personality:
		Personality.HOSTILE:
			mover_type = ComponentMoverHostile.new()
			add_child(mover_type)
	fighter_type = null
	if _def.fighter_def:
		fighter_type = ComponentFighter.new(_def.fighter_def)
		add_child(fighter_type)


func move(move_offset: Vector2i) -> void:
	map_data.unregister_blocker(self)
	grid_position += move_offset
	map_data.register_blocker(self)


func alive() -> bool:
	return mover_type != null
