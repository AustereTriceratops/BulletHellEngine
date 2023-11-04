extends Control

@export var pauseMenu: PackedScene

# ========================
# ==== CUSTOM METHODS ====
# ========================

func player_damaged(health):
	$Healthbar.set_value(health)

# ========================
# ===== NODE METHODS =====
# ========================
