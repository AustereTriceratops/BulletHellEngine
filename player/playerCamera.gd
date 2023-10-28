# TODO: should possibly be a child of Player
extends Camera2D

var playerNode: CharacterBody2D
var OFFSET_FROM_PLAYER = Vector2(0, -250)

# ========================
# ==== CUSTOM METHODS ====
# ========================
	
func player_rotated(playerRotation):
	offset = OFFSET_FROM_PLAYER.rotated(playerRotation)
	

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	playerNode = get_node('..')
	playerNode.rotated.connect(player_rotated)
	
	offset = OFFSET_FROM_PLAYER
	position_smoothing_enabled = true
	position_smoothing_speed = 1.5
