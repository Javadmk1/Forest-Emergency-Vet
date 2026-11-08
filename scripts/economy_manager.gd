extends Node
signal coins_changed(new_total: int)
var coins: int = 0

func _ready() -> void:
    coins = int(SaveManager.data.get("economy", {}).get("coins", 250))

func add_coins(amount: int) -> void:
    if amount <= 0:
        return
    coins += amount
    _save()
    coins_changed.emit(coins)

func spend_coins(amount: int) -> bool:
    if amount <= 0 or coins < amount:
        return false
    coins -= amount
    _save()
    coins_changed.emit(coins)
    return true

func _save() -> void:
    SaveManager.data["economy"]["coins"] = coins
    SaveManager.save_game()
