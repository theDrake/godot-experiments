class_name Map
extends Node2D


@export var fov_radius: int = 8

var data: MapData

@onready var _fov: FieldOfView = $FieldOfView
@onready var _generator: DungeonGenerator = $DungeonGenerator
@onready var _tiles: Node2D = $Tiles
@onready var _entities: Node2D = $Entities


func generate(player: Entity) -> void:
	data = _generator.generate_dungeon(player)
	populate()


func populate() -> void:
	data.entity_placed.connect(_entities.add_child)
	_place_tiles()
	_place_entities()


func update_fov(player_position: Vector2i) -> void:
	_fov.update_fov(data, player_position, fov_radius)
	for entity in data.entities:
		entity.visible = data.get_tile(entity.grid_position).in_view


func _place_tiles() -> void:
	for tile in data.tiles:
		_tiles.add_child(tile)


func _place_entities() -> void:
	for entity in data.entities:
		_entities.add_child(entity)
