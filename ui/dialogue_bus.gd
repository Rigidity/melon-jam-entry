extends Node

var completed_dialogues: Array[String] = []

signal dialogue_requested(dialogue: String, delay: float)

func request_dialogue(dialogue: String, delay: float) -> void:
	if not completed_dialogues.has(dialogue):
		force_dialogue(dialogue, delay)

func force_dialogue(dialogue: String, delay: float) -> void:
	dialogue_requested.emit(dialogue, delay)

func complete_dialogue(dialogue: String) -> void:
	completed_dialogues.push_back(dialogue)
