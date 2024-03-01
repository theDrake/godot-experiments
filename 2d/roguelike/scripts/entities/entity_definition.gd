class_name EntityDefinition
extends Resource


@export_category("Visuals")
@export var name: String = "Nameless"
@export var texture: AtlasTexture
@export_color_no_alpha var color: Color = Color.WHITE

@export_category("Mechanics")
@export var type: Entity.EntityType = Entity.EntityType.ACTOR
@export var blocks_movement: bool = true
@export var inventory_capacity: int = 0

@export_category("Components")
@export var fighter_def: ComponentFighterDefinition
@export var behavior: Entity.Behavior
@export var item_def: ComponentItemDefinition
