extends CanvasLayer

@onready var player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	player.play("fade_in")

func load_scene(scene: PackedScene) -> void:
	await _start_transition()
	get_tree().change_scene_to_packed(scene)
	await _stop_transition()

func reload_scene() -> void:
	await _start_transition()
	get_tree().reload_current_scene()
	await _stop_transition()

func _start_transition() -> void:
	player.play("fade_out")
	await player.animation_finished

func _stop_transition() -> void:
	await get_tree().scene_changed
	player.play("fade_in")
	await player.animation_finished
