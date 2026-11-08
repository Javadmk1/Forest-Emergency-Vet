extends Control

enum Step { CHOOSE_TOOL, REMOVE_THORN, WASH, BANDAGE, COMPLETE }
var current_step: Step = Step.CHOOSE_TOOL
var wash_count := 0
var message_label: Label
var action_button: Button
var tool_row: HBoxContainer

func _ready() -> void:
    _build_ui()
    _show_step()

func _build_ui() -> void:
    var bg := ColorRect.new()
    bg.color = Color("#244d2e")
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)

    var margin := MarginContainer.new()
    margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    margin.add_theme_constant_override("margin_left", 20)
    margin.add_theme_constant_override("margin_right", 20)
    margin.add_theme_constant_override("margin_top", 26)
    margin.add_theme_constant_override("margin_bottom", 26)
    add_child(margin)

    var layout := VBoxContainer.new()
    layout.add_theme_constant_override("separation", 18)
    margin.add_child(layout)

    var title := Label.new()
    title.text = "درمان پوپی 🐰" if LanguageManager.is_persian() else "Poppy's Treatment 🐰"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 30)
    title.add_theme_color_override("font_color", Color("#ffe39a"))
    layout.add_child(title)

    var animal := Label.new()
    animal.text = "سلام دکتر! پنجه‌ام یک خار کوچک دارد." if LanguageManager.is_persian() else "Hello, doctor! I have a tiny thorn in my paw."
    animal.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    animal.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    animal.add_theme_font_size_override("font_size", 19)
    animal.add_theme_color_override("font_color", Color.WHITE)
    layout.add_child(animal)

    var illustration := Label.new()
    illustration.text = "       🌿\n   (\_/ )\n   ( •ᴗ• )\n   / >🌵"
    illustration.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    illustration.add_theme_font_size_override("font_size", 42)
    illustration.custom_minimum_size.y = 220
    layout.add_child(illustration)

    message_label = Label.new()
    message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    message_label.add_theme_font_size_override("font_size", 20)
    message_label.add_theme_color_override("font_color", Color("#fff1c9"))
    layout.add_child(message_label)

    tool_row = HBoxContainer.new()
    tool_row.add_theme_constant_override("separation", 8)
    layout.add_child(tool_row)

    action_button = Button.new()
    action_button.custom_minimum_size.y = 64
    action_button.pressed.connect(_advance_step)
    layout.add_child(action_button)

    var back := Button.new()
    back.text = "بازگشت به نقشه" if LanguageManager.is_persian() else "Back to map"
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/level_select.tscn"))
    layout.add_child(back)

func _show_step() -> void:
    for child in tool_row.get_children():
        child.queue_free()
    match current_step:
        Step.CHOOSE_TOOL:
            message_label.text = "ابزار درست را انتخاب کن: موچین" if LanguageManager.is_persian() else "Choose the correct tool: tweezers"
            for item in [["موچین","tweezers"],["دارو","medicine"],["بانداژ","bandage"],["آب","water"]]:
                var b := Button.new()
                b.text = item[0] if LanguageManager.is_persian() else {"tweezers":"Tweezers","medicine":"Medicine","bandage":"Bandage","water":"Water"}[item[1]]
                b.custom_minimum_size = Vector2(0, 58)
                b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
                b.pressed.connect(_choose_tool.bind(item[1]))
                tool_row.add_child(b)
            action_button.visible = false
        Step.REMOVE_THORN:
            message_label.text = "آفرین! حالا خار را آرام بیرون بیاور." if LanguageManager.is_persian() else "Great! Now gently remove the thorn."
            action_button.text = "بیرون آوردن خار" if LanguageManager.is_persian() else "Remove thorn"
            action_button.visible = true
        Step.WASH:
            message_label.text = "پنجه را تمیز کن: %d از ۳" % wash_count if LanguageManager.is_persian() else "Clean the paw: %d of 3" % wash_count
            action_button.text = "شست‌وشو" if LanguageManager.is_persian() else "Wash"
            action_button.visible = true
        Step.BANDAGE:
            message_label.text = "حالا یک پانسمان نرم انجام بده." if LanguageManager.is_persian() else "Now apply a soft bandage."
            action_button.text = "بستن پانسمان" if LanguageManager.is_persian() else "Apply bandage"
            action_button.visible = true
        Step.COMPLETE:
            message_label.text = "پوپی بهتر شد! تو یک پزشک مهربانی. +۲۰ سکه" if LanguageManager.is_persian() else "Poppy feels better! You are a kind vet. +20 coins"
            action_button.text = "ادامه" if LanguageManager.is_persian() else "Continue"
            action_button.visible = true

func _choose_tool(tool: String) -> void:
    if tool == "tweezers":
        current_step = Step.REMOVE_THORN
    else:
        message_label.text = "یک بار دیگر فکر کن؛ کدام ابزار برای برداشتن خار است؟" if LanguageManager.is_persian() else "Try again: which tool removes a thorn?"
    _show_step()

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
            EconomyManager.add_coins(20)
            var unlocked: Array = SaveManager.data["progress"]["unlocked_levels"]
            if not unlocked.has(2):
                unlocked.append(2)
            SaveManager.data["progress"]["stars_per_level"]["1"] = 3
            SaveManager.data["album"]["unlocked_animals"].append("rabbit")
            SaveManager.save_game()
            get_tree().change_scene_to_file("res://scenes/level_select.tscn")
    _show_step()
