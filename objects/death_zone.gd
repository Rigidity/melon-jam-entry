extends Area2D

const DEATH = preload("uid://cib0olfmhqatv")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		AudioBus.play_sound(DEATH)
		SceneTransition.reload_scene()
