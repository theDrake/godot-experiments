class_name Dungeon
extends Node3D


enum Direction {NORTH, WEST, SOUTH, EAST}

const MIN_WALL_LEN: int = 5
const MAX_WALL_LEN: int = 9
const CHEST: PackedScene = preload("res://scenes/chest.tscn")
const COLUMN: PackedScene = preload("res://scenes/column.tscn")
const FLOORS: Array[PackedScene] = [
	preload("res://scenes/floor_a.tscn"),
	preload("res://scenes/floor_b.tscn"),
]
const GATE: PackedScene = preload("res://scenes/wall_gate.tscn")
const MISC: Array[PackedScene] = [
	preload("res://scenes/barrel.tscn"),
	preload("res://scenes/stones.tscn"),
	preload("res://scenes/stone_block.tscn"),
	preload("res://scenes/wood_structure.tscn"),
	preload("res://scenes/wood_support.tscn"),
]
const ORC: PackedScene = preload("res://scenes/orc.tscn")
const SPIKES: PackedScene = preload("res://scenes/spikes.tscn")
const STAIRS: PackedScene = preload("res://scenes/stairs.tscn")
const WALL: Array[PackedScene] = [
	preload("res://scenes/wall_plain.tscn"),
	preload("res://scenes/wall_half.tscn"),
]
const WALL_BANNERED: PackedScene = preload(
		"res://scenes/wall_narrow_bannered.tscn")
const WALL_CORNER: PackedScene = preload("res://scenes/wall_corner.tscn")

@export var hero: Hero

@onready var _current_room: Room = $StartingRoom
@onready var _primary_direction: Direction = _current_room.exit_direction


func create_new_room() -> void:
	var new_room := Room.new()
	new_room.entry_position = _current_room.exit_position + _dir_to_v3(
			_current_room.exit_direction)
	new_room.entry_direction = _current_room.exit_direction
	new_room.entry_wall_len = randi_range(MIN_WALL_LEN,
			_current_room.exit_wall_len)
	new_room.exit_direction = _get_next_room_exit_direction(
			_current_room.exit_direction)

	var room_section_len: int = randi_range(MIN_WALL_LEN, MAX_WALL_LEN)
	var build_pos: Vector3 = _current_room.exit_position + _dir_to_v3(
			new_room.entry_direction)
	build_pos = _build_room_section(new_room, build_pos,
			new_room.entry_direction, new_room.entry_wall_len, room_section_len)
	if new_room.entry_direction != new_room.exit_direction:
		new_room.exit_wall_len = randi_range(MIN_WALL_LEN, MAX_WALL_LEN)
		build_pos = _build_room_corner(new_room, build_pos)
		room_section_len = randi_range(MIN_WALL_LEN, MAX_WALL_LEN)
		build_pos = _build_room_section(new_room, build_pos,
				new_room.exit_direction, new_room.exit_wall_len,
				room_section_len)
	else:
		new_room.exit_wall_len = new_room.entry_wall_len

	_build_room_exit_wall(new_room, build_pos)
	add_child(new_room)
	_current_room = new_room


func _build_room_section(room: Room, center: Vector3, dir: Direction,
		width: int, length: int) -> Vector3:
	var half_width: int = width / 2
	var width_offset: Vector3 = _dir_to_v3(_get_direction_left(dir))
	var create_pit: bool = randf() < 0.5

	for i in length:
		if not create_pit or i != length / 2:
			room.add(_random_floor(), center, _random_direction())
		for j in range(1, half_width + 1):
			if j == half_width:
				room.add(WALL[1 if i == length / 2 else 0],
						center + (width_offset * j),
						_get_direction_opposite(_v3_to_dir(width_offset)))
				room.add(WALL[1 if i == length / 2 else 0],
						center + (width_offset * -j),
						_v3_to_dir(width_offset))
			elif not create_pit or i != length / 2:
				room.add(_random_floor(), center + (width_offset * j),
						_random_direction())
				room.add(_random_floor(), center + (width_offset * -j),
						_random_direction())
				if randf() < 0.2:
					room.add(_random_stuff(), center + (width_offset * j),
							_random_direction())
				if randf() < 0.2:
					room.add(_random_stuff(), center + (width_offset * -j),
							_random_direction())
		center += _dir_to_v3(dir)

	return center


func _build_room_corner(room: Room, center: Vector3) -> Vector3:
	var length: int = room.exit_wall_len
	var width: int = room.entry_wall_len
	var half_width: int = width / 2
	var width_offset: Vector3 = _dir_to_v3(room.exit_direction)
	var add_treasure: bool = randf() < 0.5

	for i in length:
		if i == length - 1:
			room.add(WALL[0], center, _get_direction_opposite(
					room.entry_direction))
		else:
			room.add(_random_floor(), center, _random_direction())
		for j in range(1, half_width + 1):
			if i == length - 1:
				room.add(WALL[0], center + (width_offset * j),
						_get_direction_opposite(room.entry_direction))
				room.add(WALL_CORNER if j == half_width else WALL[0],
						center + (width_offset * -j),
						_get_direction_opposite(room.entry_direction))
			elif j == half_width:
				if i == 0:
					room.add(WALL_CORNER, center + (width_offset * j))
				else:
					room.add(_random_floor(), center + (width_offset * j),
							_random_direction())
				room.add(WALL[0], center + (width_offset * -j),
						_v3_to_dir(width_offset))
			else:
				room.add(_random_floor(), center + (width_offset * j),
						_random_direction())
				room.add(_random_floor(), center + (width_offset * -j),
						_random_direction())
		center += _dir_to_v3(room.entry_direction)
	center -= _dir_to_v3(room.entry_direction) * (room.exit_wall_len / 2 + 1)
	if add_treasure:
		room.add(CHEST, center, _get_direction_opposite(room.entry_direction))
		_surround_with(SPIKES, center, room)
	elif randf() < 0.5:
		_surround_with(COLUMN, center, room)
	else:
		room.add(_random_stuff(), center + _dir_to_v3(_random_direction()),
				_random_direction())
	center += _dir_to_v3(room.exit_direction) * (room.entry_wall_len / 2 + 1)

	return center


func _build_room_exit_wall(room: Room, center: Vector3) -> void:
	room.exit_position = center
	var num_rotations: int = _get_direction_opposite(room.exit_direction)
	room.add(GATE, center, num_rotations)
	var half_width: int = room.exit_wall_len / 2
	var width_offset: Vector3 = _dir_to_v3(_get_direction_left(
			room.exit_direction))
	for i in range(1, half_width + 1):
		if i == half_width:
			room.add(WALL_CORNER, center + (width_offset * i))
			room.add(WALL_CORNER, center + (width_offset * -i))
		elif i == half_width / 2:
			room.add(WALL_BANNERED, center + (width_offset * i), num_rotations)
			room.add(WALL_BANNERED, center + (width_offset * -i), num_rotations)
		else:
			room.add(WALL[0], center + (width_offset * i), num_rotations)
			room.add(WALL[0], center + (width_offset * -i), num_rotations)


func _surround_with(object: PackedScene, center: Vector3, room: Room) -> void:
	for dir in range(0, Direction.size()):
		room.add(object, center + _dir_to_v3(dir))


func _dir_to_v3(dir: Direction) -> Vector3:
	match dir:
		Direction.NORTH:
			return Vector3(0, 0, 1.0)
		Direction.SOUTH:
			return Vector3(0, 0, -1.0)
		Direction.EAST:
			return Vector3(-1.0, 0, 0)
		_:
			return Vector3(1.0, 0, 0)


func _v3_to_dir(v: Vector3) -> Direction:
	match v.normalized():
		Vector3(0, 0, 1.0):
			return Direction.NORTH
		Vector3(0, 0, -1.0):
			return Direction.SOUTH
		Vector3(-1.0, 0, 0):
			return Direction.EAST
		_:
			return Direction.WEST


func _get_next_room_exit_direction(prev_dir: Direction) -> Direction:
	if randf() < 0.5:
		return prev_dir
	elif prev_dir != _primary_direction:
		return _primary_direction
	elif randf() < 0.5:
		return _get_direction_left(_primary_direction)
	else:
		return _get_direction_right(_primary_direction)


func _get_direction_opposite(dir: Direction) -> Direction:
	match dir:
		Direction.NORTH:
			return Direction.SOUTH
		Direction.SOUTH:
			return Direction.NORTH
		Direction.EAST:
			return Direction.WEST
		_:
			return Direction.EAST


func _get_direction_left(dir: Direction) -> Direction:
	match dir:
		Direction.NORTH:
			return Direction.WEST
		Direction.SOUTH:
			return Direction.EAST
		Direction.EAST:
			return Direction.NORTH
		_:
			return Direction.SOUTH


func _get_direction_right(dir: Direction) -> Direction:
	match dir:
		Direction.NORTH:
			return Direction.EAST
		Direction.SOUTH:
			return Direction.WEST
		Direction.EAST:
			return Direction.SOUTH
		_:
			return Direction.NORTH


func _random_direction() -> Direction:
	return randi_range(0, Direction.size() - 1) as Direction


func _random_floor() -> PackedScene:
	return FLOORS[0 if randf() < 0.75 else 1]


func _random_stuff() -> PackedScene:
	if randf() < 0.4:
		return ORC
	else:
		return MISC[randi() % MISC.size()]
