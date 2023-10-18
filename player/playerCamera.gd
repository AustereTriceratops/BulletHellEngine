# TODO: should possibly be a child of Player
extends Camera2D

var playerNode: Area2D

var offsetFromPlayer = Vector2(0, 350)
var playerPositionHistory = []
var maxHistorySize = 10

# ========================
# ==== CUSTOM METHODS ====
# ========================

func player_moved(playerPosition: Vector2):
	playerPositionHistory.append(playerPosition)
	
	if playerPositionHistory.size() > maxHistorySize:
		playerPositionHistory.remove_at(0)
	
	position = Math.average_vec2_array(playerPositionHistory) - offsetFromPlayer
	#position = playerPosition - offsetFromPlayer

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	playerNode = get_tree().get_root().get_node('Level').get_node('Player')
	playerNode.moved.connect(player_moved)
	position = playerNode.position - offsetFromPlayer

func _process(delta):
	pass
