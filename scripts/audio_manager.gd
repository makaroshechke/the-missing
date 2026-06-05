extends Node

var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var slide_player: AudioStreamPlayer
var sob_player: AudioStreamPlayer

var daydreaming = preload("res://assets/sounds/Daydreaming.mp3")
var button_click = preload("res://assets/sounds/button_click.mp3")

var slide_sounds = [
	preload("res://assets/sounds/slide paper1.mp3"),
	preload("res://assets/sounds/slide paper2.mp3")
]

var brush_sounds = [
	preload("res://assets/sounds/brush.mp3"),
	preload("res://assets/sounds/brush2.mp3")
]

var sob_sound = preload("res://assets/sounds/sob.mp3")


func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	sfx_player = AudioStreamPlayer.new()
	slide_player = AudioStreamPlayer.new()
	sob_player = AudioStreamPlayer.new()
	add_child(music_player)
	add_child(sfx_player)
	add_child(slide_player)
	add_child(sob_player)
	music_player.volume_db = -12
	sfx_player.volume_db = -3
	slide_player.volume_db = -18
	sob_player.volume_db = -5
	music_player.finished.connect(_on_music_finished)
	music_player.stream = daydreaming
	music_player.play()


func _on_music_finished() -> void:
	await get_tree().create_timer(1.0).timeout
	music_player.play()


func play_button() -> void:
	sfx_player.stream = button_click
	sfx_player.volume_db = -3
	sfx_player.play()


func play_slide() -> void:
	if slide_player.playing:
		return

	slide_player.stream = slide_sounds.pick_random()
	slide_player.volume_db = -18
	slide_player.play()


func play_brush() -> void:
	sfx_player.stream = brush_sounds.pick_random()
	sfx_player.volume_db = -3
	sfx_player.play()


func play_sob() -> void:
	if sob_player.playing:
		return

	sob_player.stream = sob_sound
	sob_player.volume_db = -5
	sob_player.play()
