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
const INVENTORY_MENU = preload("res://scenes/inventory_menu.tscn")

@export var reticle: Reticle


func get_action(player: Entity) -> Action:
	if Input.is_action_just_pressed("quit") or \
			Input.is_action_just_pressed("ui_back"):
		return ActionQuit.new(player)
	elif Input.is_action_just_pressed("wait"):
		return ActionWait.new(player)
	elif Input.is_action_just_pressed("get"):
		return ActionGet.new(player)
	elif Input.is_action_just_pressed("inventory"):
		return await use_item(player)
	elif Input.is_action_just_pressed("drop"):
		return ActionDrop.new(player, await _get_item("Drop which item?",
				player.inventory))
	elif Input.is_action_just_pressed("look"):
		await _get_grid_position(player, 0)
	elif Input.is_action_just_pressed("view_history"):
		SignalBus.toggle_view_history.emit()
	elif Input.is_action_just_pressed("ascend"):
		return ActionAscend.new(player)
	elif Input.is_action_just_pressed("descend"):
		return ActionDescend.new(player)
	else:
		for direction in DIRECTIONS:
			if Input.is_action_just_pressed(direction):
				var offset: Vector2i = DIRECTIONS[direction]
				return ActionBump.new(player, offset.x, offset.y)

	return null


func use_item(player: Entity) -> Action:
	var item: Entity = await _get_item("Use which item?", player.inventory,
			true)
	if not item:
		return null
	elif item.usable and item.usable.ranged:
		var target_position: Vector2i = await _get_grid_position(player,
				item.usable.radius, true)
		if target_position.x > -1:
			return ActionUse.new(player, item, target_position)
		return null

	return ActionUse.new(player, item)


static func random_direction() -> Vector2i:
	return DIRECTIONS[DIRECTIONS.keys().pick_random()]


func _get_item(window_title: String, inventory: ComponentInventory,
		stay_paused: bool = false) -> Entity:
	var menu: InventoryMenu = INVENTORY_MENU.instantiate()
	add_child(menu)
	if not menu.build_list(window_title, inventory):
		return null
	SignalBus.toggle_pause.emit()
	var selected_item: Entity = await menu.item_selected
	if not stay_paused or not selected_item or selected_item.equipment or (
			selected_item.usable and not selected_item.usable.ranged):
		await get_tree().physics_frame
		SignalBus.toggle_pause.emit()

	return selected_item


func _get_grid_position(player: Entity, radius: int,
		already_paused: bool = false) -> Vector2i:
	if not already_paused:
		SignalBus.toggle_pause.emit()
	var pos: Vector2i = await reticle.select_position(player, radius)
	await get_tree().physics_frame
	SignalBus.toggle_pause.emit()

	return pos
