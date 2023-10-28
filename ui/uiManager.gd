extends Control

@export var pauseMenu: PackedScene

var playerNode: Node

var trauma = 0.0
var traumaDecay = 2.0
var maxOffset = Vector2(20, 10)

# ========================
# ==== CUSTOM METHODS ====
# ========================

func player_damaged(health):
	$Healthbar.set_value(health)
	trauma = 1.0
	
func shake():
	var amount = pow(trauma, 2)
	offset_left = amount *	maxOffset.x * randf_range(-1, 1)
	offset_top = amount * maxOffset.y * randf_range(-1, 1)
	
# ========================
# ===== NODE METHODS =====
# ========================

func _process(delta):
	if trauma > 0:
		trauma = max(trauma - delta*traumaDecay, 0)
		shake()

#func _ready():
#	playerNode = get_tree().get_root().get_node("Level/Player")
#	playerNode.damaged.connect(player_damaged)
