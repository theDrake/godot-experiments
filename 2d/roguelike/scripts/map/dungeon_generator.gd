class_name DungeonGenerator
extends Node


const DEFAULT_MAX_ENEMIES_PER_ROOM: int = 1
const DEFAULT_MAX_ITEMS_PER_ROOM: int = 2
const FLOORS_PER_DIFFICULTY_INCREASE: int = 2
const ENEMIES: Array[String] = [
	"Bat",
	"Snake",
	"Beetle",
	"Goblin",
	"Spider",
	"Orc",
	"Scorpion",
	"Skeleton",
	"Slime",
	"Hobgoblin",
	"Troll",
	"Ghost",
	"Cyclops",
	"Ghoul",
	"Imp",
	"Ogre",
	"Djinn",
	"Sorcerer",
	"Demon",
]
const ITEMS: Array[Array] = [
	[ # Armor
		"Mage's Cloak",
		"Leather Boots",
		"Leather Gloves",
		"Wooden Shield",
		"Leather Armor",
		"Iron Boots",
		"Iron Gauntlets",
		"Iron Shield",
		"Iron Helm",
		"Iron Armor",
		"Steel Boots",
		"Steel Gauntlets",
		"Steel Shield",
		"Steel Helm",
		"Steel Armor",
		"Elven Boots",
		"Elven Gauntlets",
		"Elven Shield",
		"Elven Helm",
		"Elven Armor",
		"Dwarven Boots",
		"Dwarven Gauntlets",
		"Dwarven Shield",
		"Dwarven Helm",
		"Dwarven Armor",
	],
	[ # Weapons
		"Iron Dagger",
		"Iron Sword",
		"Iron Axe",
		"Steel Dagger",
		"Steel Sword",
		"Steel Axe",
		"Elven Dagger",
		"Elven Sword",
		"Elven Axe",
		"Dwarven Dagger",
		"Dwarven Sword",
		"Dwarven Axe",
	],
	[ # Usables
		"Potion of Healing",
		"Scroll of Confusion",
		"Scroll of Lightning",
		"Scroll of Fireball",
	],
]

@export_category("Map")
@export var map_width: int = 40
@export var map_height: int = 40

@export_category("Rooms")
@export var max_rooms: int = 10
@export var room_max_size: int = 10
@export var room_min_size: int = 6

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
		_place_n_random_entities_from_array(DEFAULT_MAX_ITEMS_PER_ROOM, ITEMS,
				dungeon, new_room)
		_place_n_random_entities_from_array(DEFAULT_MAX_ENEMIES_PER_ROOM,
				ENEMIES, dungeon, new_room)
		rooms.append(new_room)
	for i in range(1, rooms.size()):
		if _add_stairs_down(dungeon, rooms[-i]):
			break

	# apply special tiles
	for e in dungeon.entities:
		if e.entity_name.contains("Spider"):
			dungeon.get_tile(e.grid_position).set_tile_type(Tile.TileType.WEB)
	dungeon.get_tile(player.grid_position).set_tile_type(
			Tile.TileType.STAIRS_UP)

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


func _place_n_random_entities_from_array(n: int, array: Array, dungeon: MapData,
		room: Rect2i) -> void:
	var difficulty: int = dungeon.current_depth / FLOORS_PER_DIFFICULTY_INCREASE
	for _i in n + difficulty:
		var spawn_point := _get_entity_spawn_point(dungeon, room)
		if spawn_point.x > -1:
			if array is Array[Array]:
				var j: int = randi() % array.size()
				dungeon.entities.append(Entity.new(dungeon, spawn_point,
					array[j][_get_weighted_index(array[j].size(), difficulty)]))
			else:
				dungeon.entities.append(Entity.new(dungeon, spawn_point,
						array[_get_weighted_index(array.size(), difficulty)]))


func _get_entity_spawn_point(dungeon: MapData, room: Rect2i) -> Vector2i:
	var spawn_point := Vector2i(
			_rng.randi_range(room.position.x + 1, room.end.x - 1),
			_rng.randi_range(room.position.y + 1, room.end.y - 1))
	for entity in dungeon.entities:
		if entity.grid_position == spawn_point:
			return Vector2i(-1, -1)

	return spawn_point


func _get_weighted_index(array_size: int, difficulty: int) -> int:
	var random_float: float = randf()
	var comparison_float: float = 0
	for i in array_size:
		comparison_float += 3.0 * ((1.0 - comparison_float) /
				(1.0 + array_size - i))
		if random_float + (0.1 * difficulty) < comparison_float:
			return i

	return array_size - 1


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
