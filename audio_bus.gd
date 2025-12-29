extends Node

@export var pool_size := 20

@onready var music: AudioStreamPlayer = $MusicPlayer

var _audio_streams: Array[AudioStreamPlayer] = []
var _end_music := false

const PUZZLE_INTRO = preload("uid://b8jt1q54wygtr")
const PUZZLE_LOOP = preload("uid://d37fnwcjgytbd")
const FIGHT_INTRO = preload("uid://big1u2ljbalce")
const FIGHT_LOOP = preload("uid://c4yym0q5fybh4")

func _ready() -> void:
	for i in range(pool_size):
		var p := AudioStreamPlayer.new()
		p.bus = "SFX"
		p.name = "SFX_%d" % i
		add_child(p)
		_audio_streams.append(p)
	
	music.stream = PUZZLE_INTRO
	music.play()

func play_sound(stream: AudioStream) -> void:
	for p in _audio_streams:
		if p.playing:
			continue
		p.stream = stream
		p.play()
		return

	# Fallback: steal the first one if all are busy
	var p := _audio_streams[0]
	p.stop()
	p.stream = stream
	p.play()

func play_end_music() -> void:
	if _end_music:
		return
	
	_end_music = true
	music.stream = FIGHT_INTRO
	music.play()
	pass

func _on_music_player_finished() -> void:
	if not _end_music:
		music.stream = PUZZLE_LOOP
	else:
		music.stream = FIGHT_LOOP
	
	music.play()
