extends Node3D
## Cloud handler for a 3D platformer.
##
## Clouds bob up and down at randomized rates.


var time := 0.0
var random_number := RandomNumberGenerator.new()
var random_velocity: float
var random_time: float


func _ready():
	random_velocity = random_number.randf_range(0.1, 2.0)
	random_time = random_number.randf_range(0.1, 2.0)


func _process(delta):
	position.y += (cos(time * random_time) * random_velocity) * delta
	time += delta
