class_name ComponentEquipment
extends Component


enum Type {
	ONE_HANDED,
	TWO_HANDED,
	HEAD,
	NECK,
	BODY,
	HANDS,
	FEET,
	FINGER,
}

const MAX: Array[int] = [2, 1, 1, 1, 1, 1, 1, 10]

var type: Type
var power_bonus: int
var defense_bonus: int
var intellect_bonus: int
var equipped: bool = false


func _init(def: ComponentEquipmentDefinition) -> void:
	type = def.type
	power_bonus = def.power_bonus
	defense_bonus = def.defense_bonus
	intellect_bonus = def.intellect_bonus
