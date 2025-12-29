extends CharacterBody2D

@export var speed := 60.0
@export var ground_acceleration := 900.0
@export var air_acceleration := 700.0
@export var jump_velocity := 200.0
@export var coyote_time := 0.1
@export var jump_buffer := 0.1
@export var jump_cooldown := 0.15
@export var dash_velocity := 250.0
@export var dash_acceleration_lock_time := 0.2
@export var dash_stop_acceleration := 1000.0

@onready var collision_area: Area2D = $Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray: RayCast2D = $RayCast2D

const JUMP_SOUND = preload("uid://bndwugx0kqlsq")
const DASH_SOUND = preload("uid://b4bw7hi3mpro4")
const POISON_DEATH = preload("uid://dmyig6kd427ch")

var _jump_coyote_timer := 0.0
var _jump_buffer_timer := 0.0
var _jump_queued := false
var _has_double_jumped := false
var _jump_cooldown_timer := 0.0
var _has_dashed := false
var _facing_direction := 1.0
var _dash_timer := 0.0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("mask_1"):
		Global.toggle_mask(0)
	elif Input.is_action_just_pressed("mask_2"):
		Global.toggle_mask(1)
	elif Input.is_action_just_pressed("mask_3"):
		Global.toggle_mask(2)
	
	if not is_on_floor():
		if sprite.animation != "dash" or not sprite.is_playing():
			sprite.play("jump")
		
		if _dash_timer <= 0.0:
			velocity += get_gravity() * delta
		else:
			velocity.y = 0.0
	elif sprite.animation == "jump" or not sprite.is_playing():
		sprite.play("idle")
	
	var direction := Input.get_axis("move_left", "move_right")
	var acceleration := ground_acceleration if is_on_floor() else air_acceleration
	
	var sit_collider := ray.get_collider()
	var sitting := false
	
	if sit_collider is CollisionObject2D and sit_collider.is_in_group("corrupt_platform") and SceneTransition.is_playing and Global.current_mask != Global.Mask.POISON:
		AudioBus.play_sound(POISON_DEATH)
		SceneTransition.reload_scene()
	
	if Input.is_action_just_pressed("restart_level"):
		SceneTransition.reload_scene()
	
	if sit_collider is CollisionObject2D and sit_collider.is_in_group("gondola") and direction == 0.0:
		sprite.play("sit")
		sitting = true
	
	if direction != 0.0:
		_facing_direction = direction
		
		if is_on_floor() or sprite.animation == "sit":
			sprite.play("walk")
	elif is_on_floor() and not sitting:
		sprite.play("idle")
	
	if _dash_timer > 0.0:
		_dash_timer = maxf(_dash_timer - delta, 0.0)
		
		if _dash_timer > 0.0:
			acceleration = 0.0
	
	if sprite.animation != "dash":
		sprite.flip_h = _facing_direction < 0.0
	
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
	var is_air_jump_allowed := _has_double_jumped == false and _can_double_jump()
	var is_jump_allowed := (is_floor_jump_allowed or is_air_jump_allowed) and _jump_cooldown_timer <= 0.0
	
	if _jump_queued and is_jump_allowed:
		velocity.y = -jump_velocity
		_jump_coyote_timer = 0.0
		_jump_cooldown_timer = jump_cooldown
		
		AudioBus.play_sound(JUMP_SOUND)
		
		_reset_jump()
		
		if not is_floor_jump_allowed:
			_has_double_jumped = true
	
	if not is_on_floor() and not _has_dashed and Input.is_action_just_pressed("dash") and _can_dash():
		velocity.x = _facing_direction * dash_velocity
		_has_dashed = true
		_dash_timer = dash_acceleration_lock_time
		
		set_collision_mask_value(2, false)
		
		AudioBus.play_sound(DASH_SOUND)
		
		sprite.play("dash")
	
	move_and_slide()
	
	if is_on_floor():
		_jump_coyote_timer = coyote_time
		_has_double_jumped = false
		_has_dashed = false
		
		if len(collision_area.get_overlapping_bodies()) == 0:
			set_collision_mask_value(2, true)
		
		for i in range(get_slide_collision_count()):
			var collision := get_slide_collision(i)
			var collider := collision.get_collider()
			
			if collider is Balloon:
				collider.activated = true
				
				if sprite.animation != "sit":
					sprite.play("sit")

func _queue_jump() -> void:
	_jump_queued = true
	_jump_buffer_timer = jump_buffer

func _reset_jump() -> void:
	_jump_queued = false
	_jump_buffer_timer = 0.0

func _can_double_jump() -> bool:
	return Global.current_mask == Global.Mask.FEATHER

func _can_dash() -> bool:
	return Global.current_mask == Global.Mask.DASH
