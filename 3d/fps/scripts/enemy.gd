extends Node3D
## Enemy handler for a simple FPS game.
##
## Enemies bob up and down, look toward player, shoot when in range, etc.


@export var player: Node3D
var target_position: Vector3
var time := 0.0
var health := 100
var destroyed := false

@onready var _raycast := $RayCast as RayCast3D
@onready var _muzzle_a := $MuzzleA as AnimatedSprite3D
@onready var _muzzle_b := $MuzzleB as AnimatedSprite3D


func _ready():
	target_position = position


func _process(delta):
	self.look_at(player.position + Vector3(0, 0.5, 0), Vector3.UP, true)
	target_position.y += cos(time * 5) * delta
	time += delta
	position = target_position


func damage(amount):
	Audio.play("sounds/enemy_hurt.ogg")
	health -= amount
	if health <= 0 and !destroyed:
		destroy()


func destroy():
	Audio.play("sounds/enemy_destroy.ogg")
	destroyed = true
	queue_free()


func _on_timer_timeout():
	_raycast.force_raycast_update()
	if _raycast.is_colliding():
		var collider = _raycast.get_collider()
		if collider.has_method("damage"):
			_muzzle_a.frame = 0
			_muzzle_a.play("default")
			_muzzle_a.rotation_degrees.z = randf_range(-45, 45)
			_muzzle_b.frame = 0
			_muzzle_b.play("default")
			_muzzle_b.rotation_degrees.z = randf_range(-45, 45)
			Audio.play("sounds/enemy_attack.ogg")
			collider.damage(5)
