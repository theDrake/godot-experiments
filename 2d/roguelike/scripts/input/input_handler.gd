class_name InputHandler
extends Node


const InputModeMain := preload("res://scripts/input/input_main.gd")
const InputModeGameOver := preload("res://scripts/input/input_game_over.gd")

var input_mode: Object


func _ready() -> void:
	transition_to(InputModeMain)
	SignalBus.player_died.connect(transition_to.bind(InputModeGameOver))


func get_action(player: Entity) -> Action:
	if input_mode:
		return input_mode.get_action(player)

	return null


func transition_to(mode: Object) -> void:
	input_mode = mode
