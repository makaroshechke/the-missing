extends Node

signal language_changed

const SAVE_PATH := "user://settings.cfg"
const SECTION := "localization"
const KEY_LANG := "language"

# 0 - Русский ("ru"), 1 - Английский ("en")
var current_lang: String = "ru"

var translations: Dictionary = {
	"game_title": {
		"ru": "Пропавшая без вести",
		"en": "The Missing"
	},
	"btn_start": {
		"ru": "Начать",
		"en": "Start"
	},
	"btn_settings": {
		"ru": "Настройки",
		"en": "Settings"
	},
	"lang_button": {
		"ru": "Язык: русский",
		"en": "Language: english"
	},
	# Игровые/системные сообщения (пример)
	"hint_puzzle": {
		"ru": "Перетащите фрагменты, чтобы собрать картину.",
		"en": "Drag the pieces to complete the picture."
	},
	# Финальная сцена (EndingScene)
	"ending_text_1": {
		"ru": "По итогам 2025 года в России десятки тысяч людей\nтак и не вернулись домой , растворившись\nв статистике ненайденных .",
		"en": "According to 2025 figures in Russia , tens of thousands\n of people never made it home , dissolving\ninto the statistics of the missing ."
	},
	"ending_text_2": {
		"ru": "Единственное , что остается их близким в этой\nзвенящей тишине — это призрачная надежда\nи наши воспоминания о них .",
		"en": "All that remains for their loved ones in this\nringing silence is a faint , ghostly hope\nand our memories of them ."
	}
}

func _ready() -> void:
	load_language()

func set_language_by_index(index: int) -> void:
	set_language("en" if index == 1 else "ru")

func set_language(lang_code: String) -> void:
	if lang_code != "ru" and lang_code != "en":
		lang_code = "ru"
	current_lang = lang_code
	save_language()
	language_changed.emit()

func toggle_language() -> void:
	set_language("en" if current_lang == "ru" else "ru")

func get_lang_index() -> int:
	return 1 if current_lang == "en" else 0

func tr_key(key: String) -> String:
	if not translations.has(key):
		push_warning("Missing translation key: " + key)
		return key
	var entry: Dictionary = translations[key]
	if entry.has(current_lang):
		return str(entry[current_lang])
	return str(entry.get("ru", key))

func save_language() -> void:
	var cfg := ConfigFile.new()
	cfg.load(SAVE_PATH)
	cfg.set_value(SECTION, KEY_LANG, current_lang)
	cfg.save(SAVE_PATH)

func load_language() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) == OK:
		var saved: String = str(cfg.get_value(SECTION, KEY_LANG, "ru"))
		if saved == "ru" or saved == "en":
			current_lang = saved
