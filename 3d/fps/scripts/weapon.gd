class_name Weapon
extends Resource
## Weapon class for a simple FPS game.
##
## Provides weapon-related variables.


@export_subgroup("Model")
@export var model: PackedScene
@export var position: Vector3
@export var rotation: Vector3
@export var muzzle_position: Vector3

@export_subgroup("Properties")
@export_range(0.1, 1) var cooldown: float = 0.1 # fire rate
@export_range(1, 20) var max_distance: int = 10
@export_range(0, 100) var damage: float = 25
@export_range(0, 5) var spread: float = 0
@export_range(1, 5) var shot_count: int = 1
@export_range(0, 50) var knockback: int = 20

@export_subgroup("Sounds")
@export var sound_shoot: String # sound path

@export_subgroup("Crosshair")
@export var crosshair: Texture2D
