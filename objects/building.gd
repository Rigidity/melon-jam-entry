extends Node2D

@export var next_scene: PackedScene

func _on_exit_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	
	if next_scene:
		SceneTransition.load_scene(next_scene)
