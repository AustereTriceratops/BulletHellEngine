extends Control

@export var pauseMenu: PackedScene

# ========================
# ==== CUSTOM METHODS ====
# ========================

func initialize(player: Node2D):
    player.health_changed.connect(player_damaged)
    player.mana_changed.connect(mana_changed)

func player_damaged(health, _damage_):
    $Healthbar.set_value(health)

func mana_changed(mana):
    $ManaBar.set_value(mana)

# ========================
# ===== NODE METHODS =====
# ========================
