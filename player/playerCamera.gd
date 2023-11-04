# TODO: should possibly be a child of Player
extends Camera2D

var playerNode
var OFFSET_FROM_PLAYER = Vector2(0, -250)

# ========================
# ==== CUSTOM METHODS ====
# ========================

func initialize(playerNode_):
	playerNode = playerNode_
	playerNode.moved.connect(update_position)
	playerNode.rotated.connect(update_rotation)
	
	update_position(playerNode.position)
	update_rotation(playerNode.rotation)
	
	position_smoothing_enabled = true
	position_smoothing_speed = 1.5

	call_deferred("reset_smoothing")


func update_position(position_):
	position = position_


func update_rotation(rotation_):
	offset = OFFSET_FROM_PLAYER.rotated(rotation_)
	rotation = rotation_

# ========================
# ===== NODE METHODS =====
# ========================

