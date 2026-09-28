extends Camera2D

@export var player_character: Node2D
@export var bounds_path: NodePath = NodePath("../Levels/Level1/TileMapLayer")

func _ready() -> void:
	position_smoothing_enabled = false
	call_deferred("_apply_tilemap_bounds")

func _process(_delta: float) -> void:
	if is_instance_valid(player_character):
		global_position = player_character.global_position

func _apply_tilemap_bounds() -> void:
	var bounds_source := get_node_or_null(bounds_path) as TileMapLayer
	if bounds_source == null or bounds_source.tile_set == null:
		return
	var used_rect := bounds_source.get_used_rect()
	if used_rect.size == Vector2i.ZERO:
		return
	var tile_size := Vector2(bounds_source.tile_set.tile_size)
	var first_center := bounds_source.map_to_local(used_rect.position)
	var last_cell := used_rect.position + used_rect.size - Vector2i.ONE
	var last_center := bounds_source.map_to_local(last_cell)
	var first_corner := bounds_source.to_global(first_center - tile_size * 0.5)
	var last_corner := bounds_source.to_global(last_center + tile_size * 0.5)
	limit_left = floori(minf(first_corner.x, last_corner.x))
	limit_top = floori(minf(first_corner.y, last_corner.y))
	limit_right = ceili(maxf(first_corner.x, last_corner.x))
	limit_bottom = ceili(maxf(first_corner.y, last_corner.y))
