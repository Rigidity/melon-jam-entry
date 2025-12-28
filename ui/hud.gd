extends CanvasLayer

@onready var mask: Label = %Mask

func _process(_delta: float) -> void:
	var mask_name := "None"
	
	if Global.current_mask == Global.Mask.NONE:
		mask_name = "None"
	elif Global.current_mask == Global.Mask.FEATHER:
		mask_name = "Feather"
	
	mask.name = "Mask: " + mask_name
