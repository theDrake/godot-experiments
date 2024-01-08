class_name EventHandler
extends Node


func get_action() -> Action:
	var action: Action = null
	if Input.is_action_just_pressed("ui_up"):
		action = ActionMove.new(0, -1)
	elif Input.is_action_just_pressed("ui_down"):
		action = ActionMove.new(0, 1)
	elif Input.is_action_just_pressed("ui_left"):
		action = ActionMove.new(-1, 0)
	elif Input.is_action_just_pressed("ui_right"):
		action = ActionMove.new(1, 0)
	elif Input.is_action_just_pressed("ui_home"):
		action = ActionMove.new(-1, -1)
	elif Input.is_action_just_pressed("ui_page_up"):
		action = ActionMove.new(1, -1)
	elif Input.is_action_just_pressed("ui_page_down"):
		action = ActionMove.new(1, 1)
	elif Input.is_action_just_pressed("ui_end"):
		action = ActionMove.new(-1, 1)
	elif Input.is_action_just_pressed("ui_cancel"):
		action = ActionQuit.new()

	return action
