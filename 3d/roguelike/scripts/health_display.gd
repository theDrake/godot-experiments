class_name HealthDisplay
extends Node3D


@onready var _health_bar: ProgressBar = $HealthSubViewport/HealthBar


func update(health_ratio: float) -> void:
	_health_bar.ratio = health_ratio
