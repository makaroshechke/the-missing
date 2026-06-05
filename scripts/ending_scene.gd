extends Control

@export var menu_scene: String = "res://scenes/MainMenu.tscn"

@onready var text1: Label = $Text1
@onready var text2: Label = $Text2


func _ready() -> void:
	text1.modulate.a = 0.0
	text2.modulate.a = 0.0
	await get_tree().create_timer(1.0).timeout
	var tween := create_tween()
	tween.tween_property(text1, "modulate:a", 1.0, 2.0)
	await tween.finished
	await get_tree().create_timer(1.0).timeout
	tween = create_tween()
	tween.tween_property(text2, "modulate:a", 1.0, 2.0)
	await tween.finished
	await get_tree().create_timer(3.0).timeout
	tween = create_tween()
	tween.tween_property(text1, "modulate:a", 0.0, 2.0)
	tween.parallel().tween_property(text2, "modulate:a", 0.0, 2.0)
	await tween.finished
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file(menu_scene)
