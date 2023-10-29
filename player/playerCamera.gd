# TODO: should possibly be a child of Player
extends Camera2D

@onready var playerNode = get_node('..')
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
	playerNode.rotated.connect(player_rotated)
	
	offset = OFFSET_FROM_PLAYER
	
	position = playerNode.position
	
	position_smoothing_enabled = true
	position_smoothing_speed = 1.5

	call_deferred("reset_smoothing")
