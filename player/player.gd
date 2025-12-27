extends CharacterBody2D

@export var speed := 60.0
@export var ground_acceleration := 900.0
@export var air_acceleration := 600.0
@export var jump_velocity := 150.0
@export var coyote_time := 0.1
@export var jump_buffer := 0.1
@export var jump_cooldown := 0.15
@export var dash_velocity := 200.0
@export var dash_acceleration_lock_time := 0.15

@onready var collision_area: Area2D = $Area2D

var _jump_coyote_timer := 0.0
var _jump_buffer_timer := 0.0
var _jump_queued := false
var _has_double_jumped := false
var _jump_cooldown_timer := 0.0
var _has_dashed := false
var _facing_direction := 1.0
var _dash_timer := 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		if _dash_timer <= 0.0:
			velocity += get_gravity() * delta
		else:
			velocity.y = 0.0
	
	var direction := Input.get_axis("move_left", "move_right")
	var acceleration := ground_acceleration if is_on_floor() else air_acceleration
	
	if direction != 0.0:
		_facing_direction = direction
	
	if _dash_timer > 0.0:
		_dash_timer = maxf(_dash_timer - delta, 0.0)
		
		if _dash_timer > 0.0:
			acceleration = 0.0
	
	velocity.x = move_toward(velocity.x, direction * speed, delta * acceleration)
	
	if _jump_queued:
		_jump_buffer_timer -= delta
		
		if _jump_buffer_timer <= 0.0:
			_reset_jump()
	
	if _jump_coyote_timer > 0.0:
		_jump_coyote_timer = maxf(_jump_coyote_timer - delta, 0.0)
	
	if _jump_cooldown_timer > 0.0:
		_jump_cooldown_timer = maxf(_jump_cooldown_timer - delta, 0.0)
	
	if Input.is_action_just_pressed("jump"):
		_queue_jump()
	
	var is_floor_jump_allowed := is_on_floor() or _jump_coyote_timer > 0.0
	var is_air_jump_allowed := _has_double_jumped == false
	var is_jump_allowed := (is_floor_jump_allowed or is_air_jump_allowed) and _jump_cooldown_timer <= 0.0
	
	if _jump_queued and is_jump_allowed:
		velocity.y = -jump_velocity
		_jump_coyote_timer = 0.0
		_jump_cooldown_timer = jump_cooldown
		
		_reset_jump()
		
		if not is_floor_jump_allowed:
			_has_double_jumped = true
	
	if not is_on_floor() and not _has_dashed and Input.is_action_just_pressed("dash"):
		velocity.x = _facing_direction * dash_velocity
		_has_dashed = true
		_dash_timer = dash_acceleration_lock_time
		
		set_collision_mask_value(2, false)
	
	move_and_slide()
	
	if is_on_floor():
		_jump_coyote_timer = coyote_time
		_has_double_jumped = false
		_has_dashed = false
		
		if len(collision_area.get_overlapping_bodies()) == 0:
			set_collision_mask_value(2, true)

func _queue_jump() -> void:
	_jump_queued = true
	_jump_buffer_timer = jump_buffer

func _reset_jump() -> void:
	_jump_queued = false
	_jump_buffer_timer = 0.0
