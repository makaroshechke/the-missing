extends Area2D

var correct_position: Vector2
var is_locked: bool = false
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var snap_distance: float = 35.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

signal piece_locked


func init_piece(texture: Texture2D, start_pos: Vector2, target_pos: Vector2, piece_size: Vector2) -> void:
	input_pickable = true
	
	sprite.texture = texture
	sprite.centered = false
	sprite.position = Vector2.ZERO
	
	position = start_pos
	correct_position = target_pos
	
	var rect_shape := RectangleShape2D.new()
	rect_shape.size = piece_size
	collision_shape.shape = rect_shape
	
	# CollisionShape2D у Area2D считается от центра,
	# поэтому сдвигаем его в центр прямоугольного кусочка.
	collision_shape.position = piece_size / 2.0


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if is_locked:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = global_position - get_global_mouse_position()
			z_index = 100
		else:
			dragging = false
			z_index = 0
			_try_snap()


func _process(_delta: float) -> void:
	if dragging and not is_locked:
		global_position = get_global_mouse_position() + drag_offset
		AudioManager.play_slide()


func _try_snap() -> void:
	if global_position.distance_to(correct_position) <= snap_distance:
		global_position = correct_position
		is_locked = true
		input_pickable = false
		piece_locked.emit()
