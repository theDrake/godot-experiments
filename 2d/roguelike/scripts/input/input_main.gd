class_name InputMain
extends InputBase


const DIRECTIONS = {
	"move_up": Vector2i.UP,
	"move_down": Vector2i.DOWN,
	"move_left": Vector2i.LEFT,
	"move_right": Vector2i.RIGHT,
	"move_up_left": Vector2i.UP + Vector2i.LEFT,
	"move_up_right": Vector2i.UP + Vector2i.RIGHT,
	"move_down_left": Vector2i.DOWN + Vector2i.LEFT,
	"move_down_right": Vector2i.DOWN + Vector2i.RIGHT,
}
const INVENTORY = preload("res://scenes/inventory.tscn")


func get_action(player: Entity) -> Action:
	if Input.is_action_just_pressed("quit") or \
			Input.is_action_just_pressed("ui_back"):
		return ActionQuit.new(player)
	elif Input.is_action_just_pressed("wait"):
		return ActionWait.new(player)
	elif Input.is_action_just_pressed("get"):
		return ActionGet.new(player)
	elif Input.is_action_just_pressed("inventory"):
		return ActionUse.new(player, await get_item("Use which item?",
				player.inventory))
	elif Input.is_action_just_pressed("drop"):
		return ActionDrop.new(player, await get_item("Drop which item?",
				player.inventory))
	elif Input.is_action_just_pressed("view_history"):
		SignalBus.toggle_view_history.emit()
	else:
		for direction in DIRECTIONS:
			if Input.is_action_just_pressed(direction):
				var offset: Vector2i = DIRECTIONS[direction]
				return ActionBump.new(player, offset.x, offset.y)

	return null


func get_item(window_title: String, inventory: ComponentInventory) -> Entity:
	var menu: InventoryMenu = INVENTORY.instantiate()
	add_child(menu)
	menu.build_list(window_title, inventory)
	SignalBus.toggle_pause.emit()
	var selected_item: Entity = await menu.item_selected
	await get_tree().physics_frame
	SignalBus.toggle_pause.emit()

	return selected_item
