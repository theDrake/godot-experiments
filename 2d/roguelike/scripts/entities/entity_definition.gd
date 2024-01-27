class_name EntityDefinition
extends Resource


@export_category("Visuals")
@export var name: String = "Nameless"
@export var texture: AtlasTexture
@export_color_no_alpha var color: Color = Color.WHITE

@export_category("Mechanics")
@export var blocks_movement: bool = true
@export var type: Entity.EntityType = Entity.EntityType.ACTOR

@export_category("Components")
@export var fighter_def: ComponentFighterDefinition
@export var personality: Entity.Personality
