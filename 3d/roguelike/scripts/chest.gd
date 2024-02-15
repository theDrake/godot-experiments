class_name Chest
extends StaticBody3D


var _closed: bool = true

@onready var _anim: AnimationPlayer = $Model/AnimationPlayer
@onready var _coin: Coin = $Coin


func open() -> void:
	if _closed:
		_closed = false
		_anim.play("open")
		_coin.animate()
