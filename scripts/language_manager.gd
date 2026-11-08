extends Node
signal language_changed
var language: String = "fa"

func _ready() -> void:
    language = str(SaveManager.get_setting("language", "fa"))

func is_persian() -> bool:
    return language == "fa"

func toggle_language() -> void:
    language = "en" if language == "fa" else "fa"
    SaveManager.set_setting("language", language)
    language_changed.emit()
