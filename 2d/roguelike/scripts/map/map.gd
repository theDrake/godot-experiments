class_name Map
extends Node2D


signal environment_loaded(depth: int)

@export var fov_radius: int = 8

var data: MapData

@onready var _fov: FieldOfView = $FieldOfView
@onready var _generator: DungeonGenerator = $DungeonGenerator
@onready var _tiles: Node2D = $Tiles
@onready var _entities: Node2D = $Entities
@onready var _player_cam: Camera2D = %PlayerCamera


func _ready() -> void:
	SignalBus.player_descended.connect(next_depth)


func generate(player: Entity, depth: int) -> void:
	data = _generator.generate_dungeon(player, depth)
	populate(depth)


func populate(depth: int) -> void:
	data.entity_placed.connect(_entities.add_child)
	_place_tiles()
	_place_entities()
	environment_loaded.emit(depth)


func next_depth() -> void:
	var player: Entity = data.get_player()
	_entities.remove_child(player)
	for e in _entities.get_children():
		e.queue_free()
	for t in _tiles.get_children():
		t.queue_free()
	generate(player, data.current_depth + 1)
	_player_cam.make_current()
	_fov.clear()
	update_fov(player.grid_position)


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
