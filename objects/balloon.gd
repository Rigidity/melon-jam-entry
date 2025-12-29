class_name Balloon
extends AnimatableBody2D

@export var bounce := 50.0
@export var speed := 45.0
@export var acceleration := 200.0

var activated := false

var velocity := Vector2(0.0, 0.0)

func _ready() -> void:
	velocity.y = bounce

func _physics_process(delta: float) -> void:
	if not activated:
		return
	
	velocity.y = move_toward(velocity.y, -speed, acceleration * delta)
	
	position += velocity * delta
