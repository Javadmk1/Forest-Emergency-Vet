extends Control

func _ready() -> void:
    var bg := ColorRect.new()
    bg.color = Color("#244d2e")
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)

    var margin := MarginContainer.new()
    margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    margin.add_theme_constant_override("margin_left", 22)
    margin.add_theme_constant_override("margin_right", 22)
    margin.add_theme_constant_override("margin_top", 24)
    margin.add_theme_constant_override("margin_bottom", 24)
    add_child(margin)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 14)
    margin.add_child(column)

    var title := Label.new()
    title.text = "نقشه جنگل" if LanguageManager.is_persian() else "Forest Map"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 30)
    title.add_theme_color_override("font_color", Color("#ffe39a"))
    column.add_child(title)

    for i in range(1, 16):
        var button := Button.new()
        var level_data = _get_level(i)
        var label = "مرحله %d — %s" % [i, level_data.get("animal_name_fa", "")] if LanguageManager.is_persian() else "Level %d — %s" % [i, level_data.get("animal_name_en", "Animal")]
        button.text = label
        button.custom_minimum_size.y = 68
        button.disabled = not SaveManager.data.get("progress", {}).get("unlocked_levels", [1]).has(i)
        button.pressed.connect(_open_level.bind(i))
        column.add_child(button)

    var back := Button.new()
    back.text = "بازگشت" if LanguageManager.is_persian() else "Back"
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main_menu.tscn"))
    column.add_child(back)

func _open_level(level_id: int) -> void:
    if level_id == 1:
        get_tree().change_scene_to_file("res://scenes/treatment.tscn")
    else:
        var dialog := AcceptDialog.new()
        dialog.dialog_text = "این مرحله در حال ساخت است." if LanguageManager.is_persian() else "This level is still in development."
        add_child(dialog)
        dialog.popup_centered()

func _get_level(level_id: int) -> Dictionary:
    var path = "res://data/levels/level_%02d.json" % level_id
    if not FileAccess.file_exists(path):
        return {}
    var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
    return parsed if parsed is Dictionary else {}
