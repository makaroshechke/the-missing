extends Label

@export var translation_key: String = ""

func _ready() -> void:
	LocalizationManager.language_changed.connect(_update_text)
	_update_text()

func _update_text() -> void:
	if translation_key.is_empty():
		return
	text = LocalizationManager.tr_key(translation_key)
