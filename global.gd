extends Node


enum Mask {
	NONE = 0,
	FEATHER = 1
}

var collected_masks: Array[Mask] = []
var current_mask := Mask.NONE
