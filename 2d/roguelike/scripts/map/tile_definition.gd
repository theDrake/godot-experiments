class_name TileDefinition
extends Resource


@export_category("Visuals")
@export var texture: AtlasTexture
@export_color_no_alpha var color_lit := Color.WHITE
@export_color_no_alpha var color_dark := Color.DARK_GRAY

@export_category("Mechanics")
@export var is_walkable := true
@export var is_transparent := true
