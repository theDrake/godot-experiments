class_name Game
extends Node2D


const PlayerDef: EntityDefinition = preload(
		"res://resources/entity_definition_player.tres")

@onready var _player: Entity
@onready var _event_handler: EventHandler = $EventHandler
@onready var _entities: Node2D = $Entities
@onready var map: Map = $Map


func _ready() -> void:
	_player = Entity.new(Vector2i.ZERO, PlayerDef)
	var camera := $Camera2D
	remove_child(camera)
	_player.add_child(camera)
	_entities.add_child(_player)
	map.generate(_player)


func _physics_process(_delta: float) -> void:
	var action: Action = _event_handler.get_action()
	if action:
		action.perform(self, _player)


func get_map_data() -> MapData:
	return map.data
