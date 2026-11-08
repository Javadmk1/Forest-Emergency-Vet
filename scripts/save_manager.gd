extends Node

const SAVE_PATH := "user://player_save.json"
const BACKUP_PATH := "user://player_save.bak"
var data: Dictionary = {}

func _ready() -> void:
    load_game()

func _default_data() -> Dictionary:
    return {
        "player": {"last_played": "", "total_playtime_sec": 0},
        "progress": {"unlocked_levels": [1], "stars_per_level": {}},
        "economy": {"coins": 250, "streak_days": 0, "last_daily_reward": ""},
        "album": {"unlocked_stickers": [], "unlocked_animals": [], "tips_seen": []},
        "clinic": {"owned_items": [], "placed_items": []},
        "settings": {"sound": true, "music": true, "language": "fa", "daily_limit_min": 30}
    }

func load_game() -> void:
    if not FileAccess.file_exists(SAVE_PATH):
        data = _default_data()
        save_game()
        return
    var parsed = _read_json(SAVE_PATH)
    if parsed is Dictionary:
        data = parsed
    else:
        var backup = _read_json(BACKUP_PATH)
        data = backup if backup is Dictionary else _default_data()

func _read_json(path: String):
    if not FileAccess.file_exists(path):
        return null
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        return null
    var parser := JSON.new()
    var error := parser.parse(file.get_as_text())
    return parser.data if error == OK else null

func save_game() -> void:
    if FileAccess.file_exists(SAVE_PATH):
        var old = _read_json(SAVE_PATH)
        if old is Dictionary:
            _write_json(BACKUP_PATH, old)
    _write_json(SAVE_PATH, data)

func _write_json(path: String, value: Dictionary) -> void:
    var file := FileAccess.open(path, FileAccess.WRITE)
    if file:
        file.store_string(JSON.stringify(value, "\t"))

func get_setting(key: String, fallback = null):
    return data.get("settings", {}).get(key, fallback)

func set_setting(key: String, value) -> void:
    data["settings"][key] = value
    save_game()
