extends AnimatableBody2D

@onready var ray: RayCast2D = $RayCast2D
@onready var sprite: Sprite2D = $Sprite2D

var direction := 1.0

func _physics_process(delta: float) -> void:
	var collider := ray.get_collider()
	
	if collider is CollisionObject2D and collider.is_in_group("paline"):
		direction *= -1.0
		ray.target_position.x *= -1.0
		sprite.flip_h = not sprite.flip_h
	
	position.x += direction * delta * 32
