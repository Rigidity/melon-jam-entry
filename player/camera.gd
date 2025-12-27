extends Camera2D

@export var limit_tilemap: TileMapLayer

func _process(_delta: float) -> void:
	var used_rect := limit_tilemap.get_used_rect()
	var tile_map_size := limit_tilemap.tile_set.tile_size
	limit_left = used_rect.position.x * tile_map_size.x
	limit_top = used_rect.position.y * tile_map_size.y
	limit_right = (used_rect.position.x + used_rect.size.x) * tile_map_size.x
	limit_bottom = (used_rect.position.y + used_rect.size.y) * tile_map_size.y
