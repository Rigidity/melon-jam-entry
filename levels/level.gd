extends Node

@export var level: int = 1

func _ready() -> void:
	Global.reset_for_level(level)
	
	if level == 1:
		DialogueBus.request_dialogue("Nya?", 3.0)
		DialogueBus.request_dialogue("You suddenly wake up, finding yourself in the city of Venice...", 6.0)
	elif level == 4:
		AudioBus.play_end_music()
