extends Control

@export var pauseMenu: PackedScene

# ========================
# ==== CUSTOM METHODS ====
# ========================

func initialize(player: Node2D):
	player.damaged.connect(player_damaged)

func player_damaged(health):
	$Healthbar.set_value(health)

# ========================
# ===== NODE METHODS =====
# ========================
