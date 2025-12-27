extends CharacterBody2D

@export var speed := 60.0
@export var ground_acceleration := 900.0
@export var air_acceleration = 600.0
@export var jump_velocity := 120.0
@export var coyote_time := 0.1
@export var jump_buffer := 0.1

var _jump_coyote_timer := 0.0
var _jump_buffer_timer := 0.0
var _jump_queued = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction = Input.get_axis("move_left", "move_right")
	var acceleration = ground_acceleration if is_on_floor() else air_acceleration
	
	velocity.x = move_toward(velocity.x, direction * speed, delta * acceleration)
	
	if _jump_queued:
		_jump_buffer_timer -= delta
		
		if _jump_buffer_timer <= 0.0:
			_reset_jump()
	
	if _jump_coyote_timer > 0.0:
		_jump_coyote_timer = maxf(_jump_coyote_timer - delta, 0.0)
	
	if Input.is_action_just_pressed("jump"):
		_queue_jump()
	
	var is_jump_allowed = is_on_floor() or _jump_coyote_timer > 0.0
	
	if _jump_queued and is_jump_allowed:
		velocity.y = -jump_velocity
		_jump_coyote_timer = 0.0
		_reset_jump()
	
	move_and_slide()
	
	if is_on_floor():
		_jump_coyote_timer = coyote_time

func _queue_jump() -> void:
	_jump_queued = true
	_jump_buffer_timer = jump_buffer

func _reset_jump() -> void:
	_jump_queued = false
	_jump_buffer_timer = 0.0
