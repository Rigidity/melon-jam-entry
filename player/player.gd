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
const SWITCH_MASK_PARTICLES = preload("uid://7by4pd2n5hhx")

var _jump_coyote_timer := 0.0
var _jump_buffer_timer := 0.0
var _jump_queued := false
var _has_double_jumped := false
var _jump_cooldown_timer := 0.0
var _has_dashed := false
var _facing_direction := 1.0
var _dash_timer := 0.0
var _animation_type := "idle"

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("mask_1"):
		Global.toggle_mask(0)
		_mask_effect()
	elif Input.is_action_just_pressed("mask_2"):
		Global.toggle_mask(1)
		_mask_effect()
	elif Input.is_action_just_pressed("mask_3"):
		Global.toggle_mask(2)
		_mask_effect()
	
	if not is_on_floor():
		if _animation_type != "dash" or not sprite.is_playing():
			_animation_type = "jump"
		
		if _dash_timer <= 0.0:
			velocity += get_gravity() * delta
		else:
			velocity.y = 0.0
	elif _animation_type == "jump" or not sprite.is_playing():
		_animation_type = "idle"
	
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
		_animation_type = "sit"
		sitting = true
	
	if direction != 0.0:
		_facing_direction = direction
		
		if is_on_floor() or _animation_type == "sit":
			_animation_type = "walk"
	elif is_on_floor() and not sitting:
		_animation_type = "idle"
	
	if _dash_timer > 0.0:
		_dash_timer = maxf(_dash_timer - delta, 0.0)
		
		if _dash_timer > 0.0:
			acceleration = 0.0
	
	if _animation_type != "dash":
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
		
		_animation_type = "dash"
	
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
				
				if _animation_type != "sit":
					_animation_type = "sit"
	
	_update_animation()

func _queue_jump() -> void:
	_jump_queued = true
	_jump_buffer_timer = jump_buffer

func _reset_jump() -> void:
	_jump_queued = false
	_jump_buffer_timer = 0.0

func _can_double_jump() -> bool:
	return Global.current_mask == Global.Mask.DOUBLE_JUMP

func _can_dash() -> bool:
	return Global.current_mask == Global.Mask.DASH

func _update_animation() -> void:
	var mask_name := "none"
	
	if Global.current_mask == Global.Mask.NONE:
		mask_name = "none"
	elif Global.current_mask == Global.Mask.DOUBLE_JUMP:
		mask_name = "double_jump"
	elif Global.current_mask == Global.Mask.DASH:
		mask_name = "dash"
	elif Global.current_mask == Global.Mask.POISON:
		mask_name = "poison"
	
	var animation_name := _animation_type + "_" + mask_name
	
	if sprite.animation != animation_name:
		sprite.play(animation_name)

func _mask_effect() -> void:
	var particles := SWITCH_MASK_PARTICLES.instantiate()
	add_child(particles)
	particles.emitting = true
	await particles.finished
	particles.queue_free()
