class_name Map
extends Node2D


@export var fov_radius: int = 8

var data: MapData

@onready var _fov: FieldOfView = $FieldOfView
@onready var _generator: DungeonGenerator = $DungeonGenerator


func generate(player: Entity) -> void:
	data = _generator.generate_dungeon(player)
	_place_tiles()


func update_fov(player_position: Vector2i) -> void:
	_fov.update_fov(data, player_position, fov_radius)


func _place_tiles() -> void:
	for tile in data.tiles:
		add_child(tile)
