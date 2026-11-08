extends Control

func _ready() -> void:
    var bg := ColorRect.new()
    bg.color = Color("#244d2e")
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)
    var column := VBoxContainer.new()
    column.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    column.add_theme_constant_override("separation", 14)
    column.add_theme_constant_override("margin_left", 24)
    column.add_theme_constant_override("margin_right", 24)
    add_child(column)
    var title := Label.new()
    title.text = "نقشه جنگل" if LanguageManager.is_persian() else "Forest Map"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 30)
    column.add_child(title)
    for i in range(1, 8):
        var button := Button.new()
        var level_data = _get_level(i)
        var label = "مرحله %d — %s" % [i, level_data.get("animal_name_fa", "")] if LanguageManager.is_persian() else "Level %d — %s" % [i, level_data.get("animal_name_en", "Animal")]
        button.text = label
        button.custom_minimum_size.y = 68
        button.disabled = i > 1
        column.add_child(button)
    var back := Button.new()
    back.text = "بازگشت" if LanguageManager.is_persian() else "Back"
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main_menu.tscn"))
    column.add_child(back)

func _get_level(level_id: int) -> Dictionary:
    var path = "res://data/levels/level_%02d.json" % level_id
    if not FileAccess.file_exists(path):
        return {}
    var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
    return parsed if parsed is Dictionary else {}
