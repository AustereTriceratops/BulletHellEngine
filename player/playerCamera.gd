# TODO: should possibly be a child of Player
extends Camera2D

@export var OFFSET_FROM_PLAYER = Vector2(0, -100)

var trauma = 0.0
var traumaDecay = 2.0
var maxOffset = Vector2(20, 10)

# ========================
# ==== CUSTOM METHODS ====
# ========================

func update_rotation(rotation_):
	offset = OFFSET_FROM_PLAYER.rotated(rotation_)

func player_damaged(_health_, damage):
	trauma = 0.08*damage


func shake():
	var amount = pow(trauma, 3)
	var shakeDirection = Vector2(0, 1).rotated(randf_range(-PI, PI))
	var x = amount * maxOffset.x * shakeDirection.x
	var y = amount * maxOffset.y * shakeDirection.y
	
	offset += Vector2(x, y)

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	var playerNode = get_parent()
	playerNode.damaged.connect(player_damaged)
	
	position_smoothing_enabled = true
	position_smoothing_speed = 3

	call_deferred("reset_smoothing")

func _process(delta):
	if trauma > 0:
		trauma = max(trauma - delta*traumaDecay, 0)
		shake()
