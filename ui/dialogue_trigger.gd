extends Area2D

@export_multiline var dialogue: String
@export var delay := 7.0

var _triggered := false

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or _triggered:
		return
	
	_triggered = true
	
	DialogueBus.request_dialogue(dialogue, delay)
