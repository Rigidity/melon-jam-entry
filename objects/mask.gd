extends Area2D

@export var mask: Global.Mask

@onready var sprite: Sprite2D = $Sprite2D
@onready var particles: CPUParticles2D = $CPUParticles2D

const PICKUP = preload("uid://dmxjdfwyvvfdp")

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or not sprite.visible:
		return
	
	AudioBus.play_sound(PICKUP)
	sprite.visible = false
	particles.emitting = true
	
	Global.collected_masks.push_back(mask)
	Global.current_mask = mask
	
	await particles.finished
	queue_free()
