extends Node


enum Mask {
	NONE = 0,
	FEATHER = 1,
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
		collected_masks = [Mask.FEATHER]
		stamina = 100
		current_mask = Mask.FEATHER
	elif level == 3:
		collected_masks = [Mask.FEATHER, Mask.DASH]
		stamina = 3
		current_mask = Mask.FEATHER
	elif level == 4:
		collected_masks = [Mask.FEATHER, Mask.DASH, Mask.POISON]
		stamina = 100
		current_mask = Mask.FEATHER

func toggle_mask() -> void:
	if stamina == 0:
		AudioBus.play_sound(FAILED)
		return
	
	stamina -= 1
	
	var index := collected_masks.find(current_mask) + 1
	
	if index >= len(collected_masks):
		index = 0
	
	current_mask = collected_masks[index] if index < len(collected_masks) else Mask.NONE
	
	if current_mask != Mask.NONE:
		AudioBus.play_sound(SWITCH)
