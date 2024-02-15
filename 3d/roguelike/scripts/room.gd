class_name Room
extends Node3D


@export var exit_position: Vector3
@export var exit_direction: Dungeon.Direction
@export var exit_wall_len: int:
	set(i):
		if i % 2 == 0:
			i += 1
		exit_wall_len = i

var entry_position: Vector3
var entry_direction: Dungeon.Direction
var entry_wall_len: int:
	set(i):
		if i % 2 == 0:
			i += 1
		entry_wall_len = i


func add(scene: PackedScene, pos: Vector3, num_rotations: int = 0) -> void:
	var child: Node = scene.instantiate()
	child.position = pos
	child.rotate_y((PI / 2) * num_rotations)
	add_child(child)
