class_name ComponentFighter
extends Component


var max_hp: int
var hp: int:
	set(value):
		hp = clampi(value, 0, max_hp)
		if hp <= 0:
			die()
var defense: int
var power: int

var death_texture: Texture
#var death_color: Color


func _init(definition: ComponentFighterDefinition) -> void:
	max_hp = definition.max_hp
	hp = definition.max_hp
	defense = definition.defense
	power = definition.power
	death_texture = definition.death_texture
	#death_color = definition.death_color


func die() -> void:
	var death_message: String
	if entity == get_map_data().get_player():
		death_message = "Alas, thou hast perished!"
		SignalBus.player_died.emit()
	else:
		death_message = "%s is dead!" % entity.entity_name
	print(death_message)
	entity.texture = death_texture
	#entity.modulate = death_color
	entity.mover_type.queue_free()
	entity.mover_type = null
	entity.entity_name = "Remains of %s" % entity.entity_name
	entity.blocks_movement = false
	get_map_data().unregister_blocker(entity)
	entity.type = Entity.EntityType.CORPSE
