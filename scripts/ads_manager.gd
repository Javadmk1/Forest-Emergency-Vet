extends Node
## Safe advertising gate for a child-directed game.
## No ad is requested or displayed unless a parent enables it and a verified,
## Families-compliant AdMob plugin is installed.
signal ad_status_changed(message: String)

const REWARD_COINS := 10
var parent_ads_enabled := false
var sdk_ready := false

func _ready() -> void:
    parent_ads_enabled = bool(SaveManager.get_setting("parent_ads_enabled", false))
    # Fail closed: native ad SDK is not bundled in this scaffold.
    sdk_ready = false

func is_available() -> bool:
    return parent_ads_enabled and sdk_ready

func request_rewarded_ad() -> bool:
    if not parent_ads_enabled:
        ad_status_changed.emit("Ads are disabled by the parent.")
        return false
    if not sdk_ready:
        ad_status_changed.emit("Ad SDK is not installed/configured.")
        return false
    # Connect to the chosen plugin's rewarded-ad API.
    # Grant the reward only from its verified earned-reward callback.
    ad_status_changed.emit("Rewarded ad integration is awaiting SDK configuration.")
    return false

func grant_reward_after_verified_ad() -> void:
    if not parent_ads_enabled:
        return
    EconomyManager.add_coins(REWARD_COINS)

func set_parent_permission(enabled: bool) -> void:
    parent_ads_enabled = enabled
    SaveManager.set_setting("parent_ads_enabled", enabled)
