extends Node


enum Mask {
	NONE = 0,
	DOUBLE_JUMP = 1,
	DASH = 2,
	POISON = 3
}

var collected_masks: Array[Mask] = []
var current_mask := Mask.NONE
var stamina := 0

const SWITCH = preload("uid://doqyqteijbwxv")
const FAILED = preload("uid://dr57jbvwf7at4")

func reset_for_level(level: int) -> void:
	if level == 1:
		collected_masks = []
		stamina = 0
		current_mask = Mask.NONE
	elif level == 2:
		collected_masks = [Mask.DOUBLE_JUMP]
		stamina = 0
		current_mask = Mask.DOUBLE_JUMP
	elif level == 3:
		collected_masks = [Mask.DOUBLE_JUMP, Mask.DASH]
		stamina = 3
		current_mask = Mask.DOUBLE_JUMP
	elif level == 4:
		collected_masks = [Mask.DOUBLE_JUMP, Mask.DASH, Mask.POISON]
		stamina = 8
		current_mask = Mask.DOUBLE_JUMP

func toggle_mask(index: int) -> void:
	if index >= len(collected_masks) or index == collected_masks.find(current_mask):
		AudioBus.play_sound(FAILED)
		return
	
	if stamina <= 0:
		AudioBus.play_sound(FAILED)
		DialogueBus.force_dialogue("I'm out of stamina!", 1.0)
		DialogueBus.request_dialogue("You can press R to restart", 5.0)
		return
	
	stamina -= 1
	
	current_mask = collected_masks[index]
	
	if current_mask == Mask.DASH:
		DialogueBus.request_dialogue("Press Shift to dash!", 5.0)
	
	AudioBus.play_sound(SWITCH)
