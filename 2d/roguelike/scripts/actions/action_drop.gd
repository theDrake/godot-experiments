class_name ActionDrop
extends ActionUse


func perform() -> bool:
	return entity.inventory.drop(_item)
