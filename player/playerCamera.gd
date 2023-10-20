# TODO: should possibly be a child of Player
extends Camera2D

var playerNode: Area2D

# ========================
# ==== CUSTOM METHODS ====
# ========================

func player_moved(playerPosition):
	position = playerPosition
	
func player_rotated(playerRotation):
	rotation = playerRotation

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	playerNode = get_tree().get_root().get_node("Level").get_node("Player")
	playerNode.moved.connect(player_moved)
	playerNode.rotated.connect(player_rotated)
	position = playerNode.position
