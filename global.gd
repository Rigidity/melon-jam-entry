extends Node


enum Mask {
	NONE = 0,
	FEATHER = 1,
	DASH = 2,
	POISON = 3
}

var collected_masks: Array[Mask] = []
var current_mask := Mask.NONE
