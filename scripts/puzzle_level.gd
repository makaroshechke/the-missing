extends Control

@export var puzzle_texture: Texture2D
@export var columns: int = 2
@export var rows: int = 2
@export var next_scene: String = "res://scenes/PuzzleLevel2.tscn"
@export var enable_sob: bool = false
@export var poster_ru: Texture2D
@export var poster_en: Texture2D

@onready var next_button: Button = $NextButton
@onready var puzzle_area: Control = $PuzzleArea
@onready var pieces_parent: Node2D = $Pieces
@onready var fade_layer: ColorRect = $FadeLayer

var piece_scene: PackedScene = preload("res://scenes/PuzzlePiece.tscn")
var total_pieces: int = 0
var locked_pieces: int = 0
var sob_loop_active: bool = false
var puzzle_completed: bool = false
var transition_started: bool = false

func _ready() -> void:
	randomize()
	fade_layer.visible = true
	fade_layer.modulate.a = 1.0
	fade_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_layer.move_to_front()
	next_button.modulate.a = 0.0
	next_button.visible = false
	next_button.disabled = true
	next_button.pressed.connect(_on_next_button_pressed)
	_update_puzzle_language()
	_create_puzzle()
	_fade_in()
	if enable_sob:
		_start_sob_loop()

func _update_puzzle_language() -> void:
	if poster_ru == null or poster_en == null:
		push_error("Poster textures are not assigned!")
		return
	if LocalizationManager.current_lang == "en":
		puzzle_texture = poster_en
	else:
		puzzle_texture = poster_ru

func _create_puzzle() -> void:
	if puzzle_texture == null:
		push_error("Puzzle texture is not assigned!")
		return
	if columns <= 0 or rows <= 0:
		push_error("Columns and rows must be greater than zero!")
		return
	total_pieces = columns * rows
	locked_pieces = 0
	var texture_size: Vector2 = puzzle_texture.get_size()
	var piece_texture_size := Vector2(
		texture_size.x / columns,
		texture_size.y / rows
	)
	var piece_screen_size := Vector2(
		puzzle_area.size.x / columns,
		puzzle_area.size.y / rows
	)
	for y in range(rows):
		for x in range(columns):
			var atlas := AtlasTexture.new()
			atlas.atlas = puzzle_texture
			atlas.region = Rect2(
				Vector2(
					x * piece_texture_size.x,
					y * piece_texture_size.y
				),
				piece_texture_size
			)
			var correct_pos := puzzle_area.global_position + Vector2(
				x * piece_screen_size.x,
				y * piece_screen_size.y
			)
			var random_pos := Vector2(
				randf_range(80, 1050),
				randf_range(80, 560)
			)
			var piece = piece_scene.instantiate()
			pieces_parent.add_child(piece)
			piece.init_piece(
				atlas,
				random_pos,
				correct_pos,
				piece_screen_size
			)
			piece.rotation_degrees = 0
			piece.piece_locked.connect(_on_piece_locked)

func _on_piece_locked() -> void:
	if puzzle_completed:
		return
	locked_pieces += 1
	if locked_pieces >= total_pieces:
		_on_puzzle_completed()

func _on_puzzle_completed() -> void:
	if puzzle_completed:
		return
	puzzle_completed = true
	sob_loop_active = false
	AudioManager.play_brush()
	next_button.visible = true
	next_button.disabled = false
	next_button.move_to_front()
	next_button.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(
		next_button,
		"modulate:a",
		1.0,
		1.0
	)


func _fade_in() -> void:
	var tween := create_tween()
	tween.tween_property(
		fade_layer,
		"modulate:a",
		0.0,
		1.0
	)

func _start_sob_loop() -> void:
	var scene_tree := get_tree()
	sob_loop_active = true
	while sob_loop_active and is_inside_tree():
		AudioManager.play_sob()
		while (
			sob_loop_active
			and is_inside_tree()
			and AudioManager.sob_player.playing
		):
			await scene_tree.process_frame
		if not sob_loop_active or not is_inside_tree():
			break
		await scene_tree.create_timer(
			randf_range(5.0, 6.0)
		).timeout


func _exit_tree() -> void:
	sob_loop_active = false

func _on_next_button_pressed() -> void:
	if transition_started:
		return
	transition_started = true
	sob_loop_active = false
	next_button.disabled = true
	AudioManager.play_button()
	fade_layer.move_to_front()
	fade_layer.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(
		fade_layer,
		"modulate:a",
		1.0,
		1.0
	)
	await tween.finished
	if not is_inside_tree():
		return
	var result := get_tree().change_scene_to_file(next_scene)
	if result != OK:
		push_error("Failed to change scene: " + next_scene)
		transition_started = false
		next_button.disabled = false
