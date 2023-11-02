extends CharacterBody3D
## Player handler for a 3D platformer.
##
## Handles user input for movement, double-jumping, coin-collecting, etc.


signal coin_collected

@export_subgroup("Components")
@export var view: Node3D

@export_subgroup("Properties")
@export var movement_speed = 250
@export var jump_strength = 7

var movement_velocity: Vector3
var rotation_direction: float
var gravity = 0
var previously_floored = false
var jump_single = true
var jump_double = true
var coins = 0

@onready var particles_trail = $ParticlesTrail
@onready var sound_footsteps = $SoundFootsteps
@onready var model = $Character
@onready var animation = $Character/AnimationPlayer


func _physics_process(delta):
	handle_controls(delta)
	handle_gravity(delta)
	handle_effects()

	# movement
	var applied_velocity := velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	velocity = applied_velocity
	move_and_slide()

	# rotation
	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(velocity.z, velocity.x).angle()
	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)

	# respawn after fall
	if position.y < -10:
		get_tree().reload_current_scene()

	# scale animation
	model.scale = model.scale.lerp(Vector3(1, 1, 1), delta * 10)

	# landing
	if is_on_floor() and gravity > 2 and not previously_floored:
		model.scale = Vector3(1.25, 0.75, 1.25)
		Audio.play("res://sounds/land.ogg")
	previously_floored = is_on_floor()


func handle_effects():
	particles_trail.emitting = false
	sound_footsteps.stream_paused = true
	if is_on_floor():
		if abs(velocity.x) > 1 or abs(velocity.z) > 1:
			animation.play("walk", 0.5)
			particles_trail.emitting = true
			sound_footsteps.stream_paused = false
		else:
			animation.play("idle", 0.5)
	else:
		animation.play("jump", 0.5)


func handle_controls(delta):
	# movement
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	input = input.rotated(Vector3.UP, view.rotation.y).normalized()
	movement_velocity = input * movement_speed * delta

	# jump
	if Input.is_action_just_pressed("jump"):
		if jump_single or jump_double:
			Audio.play("res://sounds/jump.ogg")
		if jump_double:
			gravity = -jump_strength
			jump_double = false
			model.scale = Vector3(0.5, 1.5, 0.5)
		if jump_single:
			jump()


func handle_gravity(delta):
	gravity += 25 * delta
	if gravity > 0 and is_on_floor():
		jump_single = true
		gravity = 0


func jump():
	gravity = -jump_strength
	model.scale = Vector3(0.5, 1.5, 0.5)
	jump_single = false;
	jump_double = true;


func collect_coin():
	coins += 1
	coin_collected.emit(coins) # signal to update HUD
