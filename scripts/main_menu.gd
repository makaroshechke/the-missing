extends Control

@export var first_puzzle_scene: String = "res://scenes/PuzzleLevel.tscn"

@onready var start_button: Button = $StartButton
@onready var fade_layer: ColorRect = $FadeLayer

func _ready() -> void:
	fade_layer.visible = true
	fade_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_layer.move_to_front()
	fade_layer.modulate.a = 1.0
	start_button.pressed.connect(_on_start_pressed)
	var tween := create_tween()
	tween.tween_property(fade_layer, "modulate:a", 0.0, 1.0)

func _on_start_pressed() -> void:
	AudioManager.play_button()
	start_button.disabled = true
	fade_layer.move_to_front()
	fade_layer.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(fade_layer, "modulate:a", 1.0, 1.0)
	await tween.finished
	get_tree().change_scene_to_file(first_puzzle_scene)
