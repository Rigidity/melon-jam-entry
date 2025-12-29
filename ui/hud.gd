extends CanvasLayer

@onready var mask: Label = %Mask
@onready var stamina: Label = %Stamina

func _process(_delta: float) -> void:
	var mask_name := "None"
	
	if Global.current_mask == Global.Mask.NONE:
		mask_name = "None"
	elif Global.current_mask == Global.Mask.FEATHER:
		mask_name = "Double Jump"
	elif Global.current_mask == Global.Mask.DASH:
		mask_name = "Dash"
	elif Global.current_mask == Global.Mask.POISON:
		mask_name = "Anti-Poison"
	
	mask.text = "Mask: " + mask_name
	stamina.text = "Stamina: " + str(Global.stamina)
