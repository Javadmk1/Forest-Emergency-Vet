extends Control

const BUTTONS = [
    ["play", "شروع بازی", "Play Game"],
    ["map", "نقشه مراحل", "Levels Map"],
    ["clinic", "کلینیک", "Clinic"],
    ["album", "آلبوم", "Album"],
    ["shop", "فروشگاه", "Shop"],
    ["settings", "تنظیمات", "Settings"],
    ["parents", "پنل والدین", "Parental Control"]
]

var title_label: Label
var subtitle_label: Label
var buttons_box: VBoxContainer
var language_button: Button

func _ready() -> void:
    _build_ui()
    LanguageManager.language_changed.connect(_refresh_text)
    _refresh_text()

func _build_ui() -> void:
    var background := ColorRect.new()
    background.color = Color("#244d2e")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var margin := MarginContainer.new()
    margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    margin.add_theme_constant_override("margin_left", 24)
    margin.add_theme_constant_override("margin_right", 24)
    margin.add_theme_constant_override("margin_top", 28)
    margin.add_theme_constant_override("margin_bottom", 24)
    add_child(margin)

    var layout := VBoxContainer.new()
    layout.add_theme_constant_override("separation", 16)
    margin.add_child(layout)

    title_label = Label.new()
    title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title_label.add_theme_font_size_override("font_size", 34)
    title_label.add_theme_color_override("font_color", Color("#ffe39a"))
    layout.add_child(title_label)

    subtitle_label = Label.new()
    subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    subtitle_label.add_theme_font_size_override("font_size", 17)
    subtitle_label.add_theme_color_override("font_color", Color.WHITE)
    layout.add_child(subtitle_label)

    var status := Label.new()
    status.text = "🪙 %d     ❤️ 3" % EconomyManager.coins
    status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status.add_theme_font_size_override("font_size", 20)
    layout.add_child(status)

    var spacer := Control.new()
    spacer.custom_minimum_size.y = 90
    layout.add_child(spacer)

    buttons_box = VBoxContainer.new()
    buttons_box.add_theme_constant_override("separation", 10)
    layout.add_child(buttons_box)

    for item in BUTTONS:
        var button := Button.new()
        button.custom_minimum_size = Vector2(0, 64)
        button.add_theme_font_size_override("font_size", 22)
        button.pressed.connect(_on_menu_pressed.bind(item[0]))
        buttons_box.add_child(button)

    language_button = Button.new()
    language_button.custom_minimum_size = Vector2(0, 48)
    language_button.pressed.connect(LanguageManager.toggle_language)
    layout.add_child(language_button)

    var footer := Label.new()
    footer.text = "Care & Kindness  •  Learn & Grow  •  Safe for Kids"
    footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    footer.add_theme_font_size_override("font_size", 13)
    footer.add_theme_color_override("font_color", Color("#f8edc8"))
    layout.add_child(footer)

func _refresh_text() -> void:
    if not is_instance_valid(title_label):
        return
    title_label.text = "پزشک فوری جنگل" if LanguageManager.is_persian() else "Forest Emergency Vet"
    subtitle_label.text = "کمک به حیوان‌ها، ماجراجویی و یادگیری!" if LanguageManager.is_persian() else "Help animals, have fun, and learn!"
    for i in range(buttons_box.get_child_count()):
        var b := buttons_box.get_child(i) as Button
        b.text = BUTTONS[i][1] if LanguageManager.is_persian() else BUTTONS[i][2]
    language_button.text = "زبان: فارسی 🇮🇷" if LanguageManager.is_persian() else "Language: English 🇬🇧"

func _on_menu_pressed(destination: String) -> void:
    match destination:
        "play", "map":
            get_tree().change_scene_to_file("res://scenes/level_select.tscn")
        "clinic", "album", "shop", "settings", "parents":
            var message = "این بخش در مرحله بعدی توسعه ساخته می‌شود." if LanguageManager.is_persian() else "This section is scheduled for the next development milestone."
            var dialog := AcceptDialog.new()
            dialog.dialog_text = message
            add_child(dialog)
            dialog.popup_centered()
