class_name Balloon
extends AnimatableBody2D

@export var bounce := 50.0
@export var speed := 45.0
@export var acceleration := 200.0

@onready var sprite: Sprite2D = $Sprite2D

var activated := false
var velocity := Vector2(0.0, 0.0)

const BALLOON_1 = preload("uid://cvjxjy4fwa5h2")
const BALLOON_2 = preload("uid://bci4wo8aokpgu")
const BALLOON_3 = preload("uid://0o2fcb5o04kp")

func _ready() -> void:
	velocity.y = bounce
	
	var look := randi_range(1, 3)
	
	if look == 1:
		sprite.texture = BALLOON_1
	elif look == 2:
		sprite.texture = BALLOON_2
	elif look == 3:
		sprite.texture = BALLOON_3

func _physics_process(delta: float) -> void:
	if not activated:
		return
	
	velocity.y = move_toward(velocity.y, -speed, acceleration * delta)
	
	position += velocity * delta
