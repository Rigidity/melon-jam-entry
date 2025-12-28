extends Camera2D

func _ready() -> void:
	_create_boundary("left", Vector2(1.0, 0.0), limit_left)
	_create_boundary("right", Vector2(-1.0, 0.0), -limit_right)
	_create_boundary("top", Vector2(0.0, 1.0), limit_top)
	_create_boundary("bottom", Vector2(0.0, -1.0), -limit_bottom)

func _create_boundary(boundary_name: StringName, normal: Vector2, distance: float) -> void:
	var body := StaticBody2D.new()
	body.name = boundary_name
	body.add_to_group("boundary")
	body.set_collision_layer_value(1, false)
	
	var collider := CollisionShape2D.new()
	var shape := WorldBoundaryShape2D.new()
	shape.normal = normal
	shape.distance = distance
	collider.shape = shape
	
	body.add_child(collider)
	get_tree().get_root().call_deferred("add_child", body)
