class_name InventoryMenu
extends CanvasLayer


signal item_selected(item)

const INVENTORY_BUTTON := preload("res://scenes/inventory_button.tscn")

@onready var _list: VBoxContainer = $"%InventoryList"
@onready var _title: Label = $"%InventoryTitle"


func _ready() -> void:
	hide()


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_back"):
		button_pressed()


func build_list(title_text: String, inventory: ComponentInventory) -> bool:
	if inventory.items.is_empty():
		button_pressed.call_deferred()
		MessageLog.send_message("Your inventory is empty.", GameColors.INVALID)
		return false

	_title.text = title_text
	for i in inventory.items.size():
		_register_item(i, inventory.items[i])
	_list.get_child(0).grab_focus()
	show()

	return true


func button_pressed(item: Entity = null) -> void:
	await get_tree().physics_frame
	item_selected.emit(item)
	queue_free()


func _register_item(index: int, item: Entity) -> void:
	var item_button: Button = INVENTORY_BUTTON.instantiate()
	item_button.text = "( %s ) %s" % [String.chr("a".unicode_at(0) + index),
			item.entity_name]
	var shortcut_event := InputEventKey.new()
	shortcut_event.keycode = KEY_A + index
	item_button.shortcut = Shortcut.new()
	item_button.shortcut.events = [shortcut_event]
	item_button.pressed.connect(button_pressed.bind(item))
	_list.add_child(item_button)
