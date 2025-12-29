extends Node

@export var level: int = 1

func _ready() -> void:
	Global.reset_for_level(level)
