extends Control

func _wood_style(color := "#b96e2e") -> StyleBoxFlat:
    var s := StyleBoxFlat.new()
    s.bg_color = Color(color)
    s.border_color = Color("#63391f")
    s.set_border_width_all(3)
    s.set_corner_radius_all(15)
    s.shadow_color = Color(0, 0, 0, 0.3)
    s.shadow_size = 3
    s.content_margin_left = 8
    s.content_margin_right = 8
    s.content_margin_top = 6
    s.content_margin_bottom = 6
    return s

func _ready() -> void:
    var art := TextureRect.new()
    art.texture = load("res://assets/forest_menu_bg.svg")
    art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    art.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(art)

    var shade := ColorRect.new()
    shade.color = Color(0.02, 0.1, 0.04, 0.58)
    shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(shade)

    var margin := MarginContainer.new()
    margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    margin.add_theme_constant_override("margin_left", 18)
    margin.add_theme_constant_override("margin_right", 18)
    margin.add_theme_constant_override("margin_top", 20)
    margin.add_theme_constant_override("margin_bottom", 20)
    add_child(margin)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 12)
    margin.add_child(column)

    var title := Label.new()
    title.text = "نقشه جنگل" if LanguageManager.is_persian() else "Forest Map"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 30)
    title.add_theme_color_override("font_color", Color("#fff0a8"))
    title.add_theme_color_override("font_outline_color", Color("#60371d"))
    title.add_theme_constant_override("outline_size", 6)
    column.add_child(title)

    var hint := Label.new()
    hint.text = "یک مأموریت را برای کمک انتخاب کن" if LanguageManager.is_persian() else "Choose a mission and help an animal"
    hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    hint.add_theme_color_override("font_color", Color.WHITE)
    hint.add_theme_font_size_override("font_size", 16)
    column.add_child(hint)

    var scroll := ScrollContainer.new()
    scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
    column.add_child(scroll)

    var grid := GridContainer.new()
    grid.columns = 2
    grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    grid.add_theme_constant_override("h_separation", 10)
    grid.add_theme_constant_override("v_separation", 10)
    scroll.add_child(grid)

    for i in range(1, 16):
        var button := Button.new()
        var level_data = _get_level(i)
        var animal_fa := str(level_data.get("animal_name_fa", "حیوان جنگل"))
        var animal_en := str(level_data.get("animal_name_en", "Forest Animal"))
        var unlocked: Array = SaveManager.data.get("progress", {}).get("unlocked_levels", [1])
        button.text = ("⭐ %02d\n%s" % [i, animal_fa]) if LanguageManager.is_persian() else ("⭐ %02d\n%s" % [i, animal_en])
        button.custom_minimum_size = Vector2(0, 88)
        button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        button.add_theme_stylebox_override("normal", _wood_style())
        button.add_theme_stylebox_override("hover", _wood_style("#d58a3e"))
        button.add_theme_color_override("font_color", Color("#fff4d8"))
        button.add_theme_color_override("font_disabled_color", Color("#b6a58a"))
        button.add_theme_font_size_override("font_size", 17)
        button.disabled = not unlocked.has(i)
        button.pressed.connect(_open_level.bind(i))
        grid.add_child(button)

    var back := Button.new()
    back.text = "بازگشت به منو" if LanguageManager.is_persian() else "Back to Menu"
    back.custom_minimum_size.y = 54
    back.add_theme_stylebox_override("normal", _wood_style("#7c4b2a"))
    back.add_theme_color_override("font_color", Color.WHITE)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main_menu.tscn"))
    column.add_child(back)

func _open_level(level_id: int) -> void:
    if level_id == 1:
        get_tree().change_scene_to_file("res://scenes/treatment.tscn")
    else:
        var dialog := AcceptDialog.new()
        dialog.dialog_text = "این مرحله هنوز قابل بازی نیست." if LanguageManager.is_persian() else "This mission is not playable yet."
        add_child(dialog)
        dialog.popup_centered()

func _get_level(level_id: int) -> Dictionary:
    var path = "res://data/levels/level_%02d.json" % level_id
    if not FileAccess.file_exists(path):
        return {}
    var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
    return parsed if parsed is Dictionary else {}
