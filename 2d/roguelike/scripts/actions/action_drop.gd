class_name ActionDrop
extends ActionUse


func perform() -> bool:
	if _item and _item.equipment and _item.equipment.equipped:
		entity.fighter.unequip(_item, true)

	return entity.inventory.drop(_item)
