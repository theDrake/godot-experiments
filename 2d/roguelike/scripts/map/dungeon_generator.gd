class_name DungeonGenerator
extends Node


const ENEMIES = [
	"Orc",
	"Troll",
]
const ITEMS = [
	"Potion of Healing",
	"Scroll of Lightning",
	"Scroll of Fireball",
	"Scroll of Confusion",
]

@export_category("Map")
@export var map_width: int = 40
@export var map_height: int = 40

@export_category("Rooms")
@export var max_rooms: int = 10
@export var room_max_size: int = 10
@export var room_min_size: int = 6

@export_category("Entities")
@export var max_monsters_per_room: int = 2
@export var max_items_per_room: int = 4

var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()


func generate_dungeon(player: Entity, depth: int) -> MapData:
	var dungeon := MapData.new(map_width, map_height)
	dungeon.current_depth = depth
	dungeon.entities.append(player)
	var rooms: Array[Rect2i] = []
	for _try_room in max_rooms:
		var room_width: int = _rng.randi_range(room_min_size, room_max_size)
		var room_height: int = _rng.randi_range(room_min_size, room_max_size)
		var x: int = _rng.randi_range(0, dungeon.width - room_width - 1)
		var y: int = _rng.randi_range(0, dungeon.height - room_height - 1)
		var new_room := Rect2i(x, y, room_width, room_height)
		var has_intersections := false
		for room in rooms:
			if room.intersects(new_room.grow(-1)):
				has_intersections = true
				break
		if has_intersections:
			continue
		_carve_room(dungeon, new_room)
		if rooms.is_empty():
			player.grid_position = new_room.get_center()
			player.map_data = dungeon
		else:
			_tunnel_between(dungeon, rooms.back().get_center(),
					new_room.get_center())
		_place_entities(dungeon, new_room)
		rooms.append(new_room)
	for i in range(1, rooms.size()):
		if _add_stairs_down(dungeon, rooms[-i]):
			break
	dungeon.init_pathfinder()

	return dungeon


func _add_stairs_down(dungeon: MapData, room: Rect2i) -> bool:
	var center: Vector2i = room.get_center()
	var pos: Vector2i = center
	for _num_tries in InputMain.DIRECTIONS.size():
		var t: Tile = dungeon.get_tile(pos)
		if not dungeon.get_entity_at(pos):
			t.set_tile_type(Tile.TileType.STAIRS_DOWN)
			return true
		pos = center + InputMain.random_direction()

	return false


func _place_entities(dungeon: MapData, room: Rect2i) -> void:
	for _i in _rng.randi_range(0, max_monsters_per_room):
		var spawn_point := _get_entity_spawn_point(dungeon, room)
		if spawn_point.x > -1:
			dungeon.entities.append(Entity.new(dungeon, spawn_point,
					ENEMIES.pick_random()))
	for _i in _rng.randi_range(0, max_items_per_room):
		var spawn_point := _get_entity_spawn_point(dungeon, room)
		if spawn_point.x > -1:
			dungeon.entities.append(Entity.new(dungeon, spawn_point,
					ITEMS.pick_random()))


func _get_entity_spawn_point(dungeon: MapData, room: Rect2i) -> Vector2i:
	var spawn_point := Vector2i(
			_rng.randi_range(room.position.x + 1, room.end.x - 1),
			_rng.randi_range(room.position.y + 1, room.end.y - 1))
	for entity in dungeon.entities:
		if entity.grid_position == spawn_point:
			return Vector2i(-1, -1)

	return spawn_point


func _carve_tile(dungeon: MapData, x: int, y: int) -> void:
		dungeon.get_tile(Vector2i(x, y)).set_tile_type(Tile.TileType.FLOOR)


func _carve_room(dungeon: MapData, room: Rect2i) -> void:
	var inner: Rect2i = room.grow(-1)
	for y in range(inner.position.y, inner.end.y + 1):
		for x in range(inner.position.x, inner.end.x + 1):
			_carve_tile(dungeon, x, y)


func _tunnel_between(dungeon: MapData, start: Vector2i, end: Vector2i) -> void:
	if _rng.randf() < 0.5:
		_tunnel_horizontal(dungeon, start.y, start.x, end.x)
		_tunnel_vertical(dungeon, end.x, start.y, end.y)
	else:
		_tunnel_vertical(dungeon, start.x, start.y, end.y)
		_tunnel_horizontal(dungeon, end.y, start.x, end.x)


func _tunnel_horizontal(dungeon: MapData, y: int, x1: int, x2: int) -> void:
	for x in range(mini(x1, x2), maxi(x1, x2) + 1):
		_carve_tile(dungeon, x, y)


func _tunnel_vertical(dungeon: MapData, x: int, y1: int, y2: int) -> void:
	for y in range(mini(y1, y2), maxi(y1, y2) + 1):
		_carve_tile(dungeon, x, y)
