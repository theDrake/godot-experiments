class_name Game
extends Node3D


@onready var _dungeon: Dungeon = $Dungeon


func _on_gate_opened() -> void:
	_dungeon.create_new_room()


func _on_hero_died() -> void:
	await get_tree().create_timer(2.0).timeout
	_dungeon.queue_free()
	get_tree().reload_current_scene()
