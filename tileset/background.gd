extends TileMapLayer


func _ready() -> void:
	var used_rect := get_used_rect()
	var tile_map_size := tile_set.tile_size
	var limit_left := used_rect.position.x * tile_map_size.x
	var limit_top := used_rect.position.y * tile_map_size.y
	var limit_right := (used_rect.position.x + used_rect.size.x) * tile_map_size.x
	var limit_bottom := (used_rect.position.y + used_rect.size.y) * tile_map_size.y
	
	_create_boundary(Vector2(1.0, 0.0), limit_left)
	_create_boundary(Vector2(-1.0, 0.0), -limit_right)
	_create_boundary(Vector2(0.0, 1.0), limit_top)
	_create_boundary(Vector2(0.0, -1.0), -limit_bottom)

func _create_boundary(normal: Vector2, distance: float) -> void:
	var body := StaticBody2D.new()
	body.add_to_group("boundary")
	
	var collider := CollisionShape2D.new()
	var shape := WorldBoundaryShape2D.new()
	shape.normal = normal
	shape.distance = distance
	collider.shape = shape
	
	body.add_child(collider)
	add_child(body)
