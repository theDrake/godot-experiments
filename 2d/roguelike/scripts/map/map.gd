class_name Map
extends Node2D


var data: MapData

@onready var dungeon_generator: DungeonGenerator = $DungeonGenerator


func generate(player: Entity) -> void:
	data = dungeon_generator.generate_dungeon(player)
	_place_tiles()


func _place_tiles() -> void:
	for tile in data.tiles:
		add_child(tile)
