extends CanvasLayer

@export var char_delay := 0.035

@onready var mask: Label = %Mask
@onready var stamina: Label = %Stamina
@onready var dialogue_label: Label = $DialogueBox/DialogueText

var _queue: Array[Array] = []
var _char_timer := 0.0
var _current := ""
var _typing := false
var _delay := 0.0

func _ready() -> void:
	DialogueBus.dialogue_requested.connect(_on_dialogue_requested)
	dialogue_label.text = ""

func _process(delta: float) -> void:
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
	
	_update_dialogue(delta)

func _on_dialogue_requested(dialogue: String, delay: float) -> void:
	if dialogue == _current:
		return
	
	for item in _queue:
		if item[0] == dialogue:
			return
	
	_queue.push_back([dialogue, delay])

func _start_dialogue(dialogue: String, delay: float) -> void:
	_current = dialogue
	_delay = delay
	_char_timer = 0.0
	_typing = true
	
	visible = true

	# Set full text so wrapping is computed up front
	dialogue_label.text = _current
	dialogue_label.visible_characters = 0

func _update_dialogue(delta: float) -> void:
	# Start the next dialogue
	if _current == "":
		if not _queue.is_empty():
			var next: Variant = _queue.pop_front()
			_start_dialogue(next[0], next[1])
		else:
			dialogue_label.text = ""
			return

	# Typewriter reveal
	_char_timer += delta
	
	if _typing:
		while _char_timer >= char_delay and _typing:
			_char_timer -= char_delay
			dialogue_label.visible_characters += 1

			if dialogue_label.visible_characters >= dialogue_label.get_total_character_count():
				_typing = false
				_char_timer = 0.0
	else:
		_char_timer += delta
		
		if _char_timer >= _delay:
			DialogueBus.complete_dialogue(_current)
			_current = ""
