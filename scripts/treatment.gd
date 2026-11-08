extends Control

enum Step { CHOOSE_TOOL, REMOVE_THORN, WASH, BANDAGE, COMPLETE }
var current_step: Step = Step.CHOOSE_TOOL
var wash_count := 0
var message_label: Label
var action_button: Button
var tool_row: HBoxContainer
var progress_label: Label

func _wood_style(color := "#b96e2e") -> StyleBoxFlat:
    var s := StyleBoxFlat.new()
    s.bg_color = Color(color)
    s.border_color = Color("#63391f")
    s.set_border_width_all(3)
    s.set_corner_radius_all(16)
    s.shadow_color = Color(0, 0, 0, 0.3)
    s.shadow_size = 4
    s.content_margin_left = 10
    s.content_margin_right = 10
    s.content_margin_top = 7
    s.content_margin_bottom = 7
    return s

func _style_button(b: Button, size := 18) -> void:
    b.add_theme_stylebox_override("normal", _wood_style())
    b.add_theme_stylebox_override("hover", _wood_style("#d58a3e"))
    b.add_theme_stylebox_override("pressed", _wood_style("#874a25"))
    b.add_theme_color_override("font_color", Color("#fff4d8"))
    b.add_theme_font_size_override("font_size", size)

func _ready() -> void:
    _build_ui()
    _show_step()

func _build_ui() -> void:
    var art := TextureRect.new()
    art.texture = load("res://assets/clinic_interior.svg")
    art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    art.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(art)

    var shade := ColorRect.new()
    shade.color = Color(0.03, 0.1, 0.04, 0.62)
    shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(shade)

    var margin := MarginContainer.new()
    margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    margin.add_theme_constant_override("margin_left", 18)
    margin.add_theme_constant_override("margin_right", 18)
    margin.add_theme_constant_override("margin_top", 22)
    margin.add_theme_constant_override("margin_bottom", 18)
    add_child(margin)

    var layout := VBoxContainer.new()
    layout.add_theme_constant_override("separation", 10)
    margin.add_child(layout)

    var title := Label.new()
    title.text = "درمان پوپی 🐰" if LanguageManager.is_persian() else "Poppy's Treatment 🐰"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 27)
    title.add_theme_color_override("font_color", Color("#fff0a8"))
    title.add_theme_color_override("font_outline_color", Color("#60371d"))
    title.add_theme_constant_override("outline_size", 5)
    layout.add_child(title)

    progress_label = Label.new()
    progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    progress_label.add_theme_font_size_override("font_size", 15)
    progress_label.add_theme_color_override("font_color", Color.WHITE)
    layout.add_child(progress_label)

    var animal_panel := PanelContainer.new()
    var panel_style := StyleBoxFlat.new()
    panel_style.bg_color = Color(0.96, 0.89, 0.72, 0.94)
    panel_style.border_color = Color("#a76631")
    panel_style.set_border_width_all(4)
    panel_style.set_corner_radius_all(22)
    panel_style.content_margin_left = 8
    panel_style.content_margin_right = 8
    panel_style.content_margin_top = 8
    panel_style.content_margin_bottom = 8
    animal_panel.add_theme_stylebox_override("panel", panel_style)
    animal_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
    layout.add_child(animal_panel)

    var animal_column := VBoxContainer.new()
    animal_column.add_theme_constant_override("separation", 4)
    animal_panel.add_child(animal_column)

    var rabbit := TextureRect.new()
    rabbit.texture = load("res://assets/rabbit_patient.svg")
    rabbit.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    rabbit.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
    rabbit.custom_minimum_size = Vector2(0, 250)
    rabbit.size_flags_vertical = Control.SIZE_EXPAND_FILL
    animal_column.add_child(rabbit)

    var animal := Label.new()
    animal.text = "سلام دکتر! پنجه‌ام به کمک نیاز دارد." if LanguageManager.is_persian() else "Hello, doctor! My paw needs your help."
    animal.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    animal.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    animal.add_theme_font_size_override("font_size", 17)
    animal.add_theme_color_override("font_color", Color("#56351f"))
    animal_column.add_child(animal)

    message_label = Label.new()
    message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    message_label.add_theme_font_size_override("font_size", 18)
    message_label.add_theme_color_override("font_color", Color("#fff5d6"))
    message_label.add_theme_color_override("font_outline_color", Color("#53321d"))
    message_label.add_theme_constant_override("outline_size", 3)
    layout.add_child(message_label)

    tool_row = HBoxContainer.new()
    tool_row.add_theme_constant_override("separation", 7)
    layout.add_child(tool_row)

    action_button = Button.new()
    action_button.custom_minimum_size.y = 58
    _style_button(action_button, 19)
    action_button.pressed.connect(_advance_step)
    layout.add_child(action_button)

    var back := Button.new()
    back.text = "بازگشت به نقشه" if LanguageManager.is_persian() else "Back to Map"
    back.custom_minimum_size.y = 46
    _style_button(back, 16)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/level_select.tscn"))
    layout.add_child(back)

func _show_step() -> void:
    for child in tool_row.get_children():
        child.queue_free()
    var fa := LanguageManager.is_persian()
    var labels := ["انتخاب ابزار", "برداشتن خار", "شست‌وشو", "پانسمان", "پایان درمان"] if fa else ["Choose Tool", "Remove Thorn", "Clean Paw", "Bandage", "Treatment Complete"]
    progress_label.text = "مرحله %d از ۵  •  %s" % [int(current_step) + 1, labels[int(current_step)]] if fa else "Step %d of 5  •  %s" % [int(current_step) + 1, labels[int(current_step)]]
    match current_step:
        Step.CHOOSE_TOOL:
            message_label.text = "ابزار مناسب برای برداشتن خار را انتخاب کن." if fa else "Choose the right tool to remove the thorn."
            for item in [["🗜️ موچین","Tweezers","tweezers"],["💊 دارو","Medicine","medicine"],["🩹 بانداژ","Bandage","bandage"],["💧 آب","Water","water"]]:
                var b := Button.new()
                b.text = item[0] if fa else item[1]
                b.custom_minimum_size = Vector2(0, 58)
                b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
                _style_button(b, 14)
                b.pressed.connect(_choose_tool.bind(item[2]))
                tool_row.add_child(b)
            action_button.visible = false
        Step.REMOVE_THORN:
            message_label.text = "آفرین! خار را با دقت و آرامی بردار." if fa else "Great! Carefully remove the thorn."
            action_button.text = "برداشتن خار" if fa else "Remove Thorn"
            action_button.visible = true
        Step.WASH:
            message_label.text = "پنجه را تمیز کن: %d از ۳" % wash_count if fa else "Clean the paw: %d of 3" % wash_count
            action_button.text = "💧 شست‌وشو" if fa else "💧 Wash"
            action_button.visible = true
        Step.BANDAGE:
            message_label.text = "حالا یک پانسمان نرم انجام بده." if fa else "Now apply a soft bandage."
            action_button.text = "🩹 بستن پانسمان" if fa else "🩹 Apply Bandage"
            action_button.visible = true
        Step.COMPLETE:
            message_label.text = "پوپی بهتر شد! تو یک دامپزشک مهربانی. +۲۰ سکه" if fa else "Poppy feels better! You are a kind vet. +20 coins"
            action_button.text = "ادامه" if fa else "Continue"
            action_button.visible = true

func _choose_tool(tool: String) -> void:
    if tool == "tweezers":
        current_step = Step.REMOVE_THORN
        _show_step()
    else:
        message_label.text = "یک بار دیگر فکر کن؛ کدام ابزار خار را برمی‌دارد؟" if LanguageManager.is_persian() else "Try again: which tool removes a thorn?"

func _advance_step() -> void:
    match current_step:
        Step.REMOVE_THORN:
            current_step = Step.WASH
        Step.WASH:
            wash_count += 1
            if wash_count >= 3:
                current_step = Step.BANDAGE
        Step.BANDAGE:
            current_step = Step.COMPLETE
        Step.COMPLETE:
            var progress: Dictionary = SaveManager.data["progress"]
            var completed: Array = progress.get("completed_levels", [])
            var first_completion := not completed.has(1)
            if first_completion:
                completed.append(1)
                progress["completed_levels"] = completed
                var unlocked: Array = progress.get("unlocked_levels", [])
                if not unlocked.has(2):
                    unlocked.append(2)
                progress["unlocked_levels"] = unlocked
                var stars: Dictionary = progress.get("stars_per_level", {})
                stars["1"] = 3
                progress["stars_per_level"] = stars
                var album: Array = SaveManager.data["album"].get("unlocked_animals", [])
                if not album.has("rabbit"):
                    album.append("rabbit")
                SaveManager.data["album"]["unlocked_animals"] = album
                EconomyManager.add_coins(20)
            SaveManager.save_game()
            get_tree().change_scene_to_file("res://scenes/level_select.tscn")
    _show_step()
