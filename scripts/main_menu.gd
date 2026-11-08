extends Control

const BUTTONS = [
    ["play", "شروع بازی", "Play Game"],
    ["map", "نقشه مراحل", "Forest Map"],
    ["clinic", "کلینیک", "Clinic"],
    ["album", "آلبوم حیوانات", "Animal Album"],
    ["shop", "فروشگاه", "Shop"],
    ["settings", "تنظیمات", "Settings"],
    ["parents", "بخش والدین", "Parents"]
]

var title_label: Label
var subtitle_label: Label
var buttons_box: VBoxContainer
var language_button: Button
var status_label: Label

func _ready() -> void:
    _build_ui()
    LanguageManager.language_changed.connect(_refresh_text)
    _refresh_text()

func _wood_style() -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = Color("#b96e2e")
    style.border_color = Color("#61351d")
    style.set_border_width_all(4)
    style.set_corner_radius_all(18)
    style.shadow_color = Color(0, 0, 0, 0.35)
    style.shadow_size = 5
    style.shadow_offset = Vector2(0, 4)
    style.content_margin_left = 12
    style.content_margin_right = 12
    style.content_margin_top = 7
    style.content_margin_bottom = 7
    return style

func _style_button(button: Button, font_size := 20) -> void:
    var normal := _wood_style()
    var hover := _wood_style()
    hover.bg_color = Color("#d58a3e")
    var pressed := _wood_style()
    pressed.bg_color = Color("#8f4c25")
    button.add_theme_stylebox_override("normal", normal)
    button.add_theme_stylebox_override("hover", hover)
    button.add_theme_stylebox_override("pressed", pressed)
    button.add_theme_stylebox_override("focus", hover)
    button.add_theme_color_override("font_color", Color("#fff4d8"))
    button.add_theme_color_override("font_hover_color", Color.WHITE)
    button.add_theme_color_override("font_pressed_color", Color("#ffe9a7"))
    button.add_theme_color_override("font_outline_color", Color("#4b2917"))
    button.add_theme_constant_override("outline_size", 3)
    button.add_theme_font_size_override("font_size", font_size)

func _build_ui() -> void:
    var art := TextureRect.new()
    art.texture = load("res://assets/forest_menu_bg.svg")
    art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    art.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(art)

    var shade := ColorRect.new()
    shade.color = Color(0.04, 0.12, 0.07, 0.22)
    shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(shade)

    var margin := MarginContainer.new()
    margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    margin.add_theme_constant_override("margin_left", 22)
    margin.add_theme_constant_override("margin_right", 22)
    margin.add_theme_constant_override("margin_top", 22)
    margin.add_theme_constant_override("margin_bottom", 18)
    add_child(margin)

    var layout := VBoxContainer.new()
    layout.add_theme_constant_override("separation", 10)
    margin.add_child(layout)

    title_label = Label.new()
    title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title_label.add_theme_font_size_override("font_size", 32)
    title_label.add_theme_color_override("font_color", Color("#fff0a8"))
    title_label.add_theme_color_override("font_outline_color", Color("#633617"))
    title_label.add_theme_constant_override("outline_size", 7)
    layout.add_child(title_label)

    subtitle_label = Label.new()
    subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    subtitle_label.add_theme_font_size_override("font_size", 15)
    subtitle_label.add_theme_color_override("font_color", Color("#fff8df"))
    subtitle_label.add_theme_color_override("font_outline_color", Color("#294b2c"))
    subtitle_label.add_theme_constant_override("outline_size", 4)
    layout.add_child(subtitle_label)

    status_label = Label.new()
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status_label.add_theme_font_size_override("font_size", 18)
    status_label.add_theme_color_override("font_color", Color("#fff3c4"))
    status_label.add_theme_color_override("font_outline_color", Color("#57351e"))
    status_label.add_theme_constant_override("outline_size", 4)
    layout.add_child(status_label)

    var spacer := Control.new()
    spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
    layout.add_child(spacer)

    var panel := PanelContainer.new()
    var panel_style := StyleBoxFlat.new()
    panel_style.bg_color = Color(0.16, 0.09, 0.04, 0.76)
    panel_style.border_color = Color("#e5ae57")
    panel_style.set_border_width_all(3)
    panel_style.set_corner_radius_all(24)
    panel_style.content_margin_left = 12
    panel_style.content_margin_right = 12
    panel_style.content_margin_top = 12
    panel_style.content_margin_bottom = 12
    panel.add_theme_stylebox_override("panel", panel_style)
    layout.add_child(panel)

    buttons_box = VBoxContainer.new()
    buttons_box.add_theme_constant_override("separation", 8)
    panel.add_child(buttons_box)

    for item in BUTTONS:
        var button := Button.new()
        button.custom_minimum_size = Vector2(0, 54)
        _style_button(button, 19)
        button.pressed.connect(_on_menu_pressed.bind(item[0]))
        buttons_box.add_child(button)

    language_button = Button.new()
    language_button.custom_minimum_size = Vector2(0, 44)
    _style_button(language_button, 16)
    language_button.pressed.connect(LanguageManager.toggle_language)
    layout.add_child(language_button)

    var footer := Label.new()
    footer.text = "CARE • RESCUE • PROTECT" if not LanguageManager.is_persian() else "مراقبت • نجات • مهربانی"
    footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    footer.add_theme_font_size_override("font_size", 13)
    footer.add_theme_color_override("font_color", Color("#fff1c7"))
    footer.add_theme_color_override("font_outline_color", Color("#31552f"))
    footer.add_theme_constant_override("outline_size", 3)
    layout.add_child(footer)

func _refresh_text() -> void:
    if not is_instance_valid(title_label):
        return
    var fa := LanguageManager.is_persian()
    title_label.text = "پزشک فوری جنگل" if fa else "Forest Emergency Vet"
    subtitle_label.text = "به نجات حیوانات جنگل کمک کن!" if fa else "Become a hero for forest animals!"
    status_label.text = "🪙 %d سکه   •   ❤️ ۳ جان" % EconomyManager.coins if fa else "🪙 %d Coins   •   ❤️ 3 Hearts" % EconomyManager.coins
    for i in range(buttons_box.get_child_count()):
        var b := buttons_box.get_child(i) as Button
        b.text = BUTTONS[i][1] if fa else BUTTONS[i][2]
    language_button.text = "🌐 زبان: فارسی  |  English" if fa else "🌐 Language: English  |  فارسی"

func _on_menu_pressed(destination: String) -> void:
    match destination:
        "play", "map":
            get_tree().change_scene_to_file("res://scenes/level_select.tscn")
        "clinic":
            get_tree().change_scene_to_file("res://scenes/treatment.tscn")
        "album", "shop", "settings", "parents":
            var fa := LanguageManager.is_persian()
            var message := "این بخش در به‌روزرسانی بعدی تکمیل می‌شود." if fa else "This section is planned for a future update."
            var dialog := AcceptDialog.new()
            dialog.dialog_text = message
            add_child(dialog)
            dialog.popup_centered()
