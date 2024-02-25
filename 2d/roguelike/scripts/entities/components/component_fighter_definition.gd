class_name ComponentFighterDefinition
extends Resource


@export_category("Stats")
@export var max_hp: int
@export var power: int
@export var defense: int
@export var xp: int = 0
@export var level: int = 1
@export var level_up_base: int = 0
@export var level_up_factor: int = 150

@export_category("Visuals")
@export var death_texture: AtlasTexture = preload(
		"res://resources/default_death_texture.tres")
#@export var death_color: Color = Color.DARK_RED
