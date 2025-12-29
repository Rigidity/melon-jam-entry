extends Node

@export var level: int = 1

func _ready() -> void:
	Global.reset_for_level(level)
	
	if level == 1:
		DialogueBus.request_dialogue("Nya?", 3.0)
		DialogueBus.request_dialogue("You suddenly wake up, finding yourself in the city of Venice...", 6.0)
	elif level == 2:
		DialogueBus.force_dialogue("You can now double jump to reach higher", 5.0)
	elif level == 3:
		DialogueBus.force_dialogue("You can switch masks by pressing 1 and 2", 5.0)
	elif level == 4:
		DialogueBus.request_dialogue("\"Hello again kitten\"", 3.0)
		DialogueBus.request_dialogue("What is it this time mask man?", 3.0)
		DialogueBus.request_dialogue("\"I'm here to warn you, but it seems you've already noticed the poison ahead.\"", 5.0)
		DialogueBus.request_dialogue("\"This is the last time we meet.\"", 3.0)
		AudioBus.play_end_music()
