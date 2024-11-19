# TODO: should possibly be a child of Player
extends Camera2D

var playerNode
var OFFSET_FROM_PLAYER = Vector2(0, -200)

var trauma = 0.0
var traumaDecay = 2.0
var maxOffset = Vector2(20, 10)

# ========================
# ==== CUSTOM METHODS ====
# ========================

func initialize(playerNode_):
	playerNode = playerNode_
	playerNode.moved.connect(update_position)
	playerNode.rotated.connect(update_rotation)
	playerNode.damaged.connect(player_damaged)
	
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


func player_damaged(health_):
	trauma = 0.8


func shake():
	var amount = pow(trauma, 3)
	var shakeDirection = Vector2(0, 1).rotated(randf_range(-PI, PI))
	var x = amount * maxOffset.x * shakeDirection.x
	var y = amount * maxOffset.y * shakeDirection.y
	
	offset += Vector2(x, y)

# ========================
# ===== NODE METHODS =====
# ========================

func _process(delta):
	if trauma > 0:
		trauma = max(trauma - delta*traumaDecay, 0)
		shake()
