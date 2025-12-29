extends AnimatableBody2D

@export var is_dark := false

@onready var ray: RayCast2D = $RayCast2D
@onready var sprite: Sprite2D = $Sprite2D

var direction := 1.0

const DARK_GONDOLA = preload("uid://svrs4xt6n3cx")

func _ready() -> void:
	if is_dark:
		sprite.texture = DARK_GONDOLA

func _physics_process(delta: float) -> void:
	var collider := ray.get_collider()
	
	if collider is CollisionObject2D and collider.is_in_group("paline"):
		direction *= -1.0
		ray.target_position.x *= -1.0
		sprite.flip_h = not sprite.flip_h
	
	var speed := 56.0 if is_dark else 32.0
	
	position.x += direction * delta * speed
