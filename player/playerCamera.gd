# TODO: should possibly be a child of Player
extends Camera2D

@export var OFFSET_FROM_PLAYER = Vector2(0, -100)

var trauma = 0.0
var traumaDecay = 2.0
var maxOffset = Vector2(20, 10)
var baseOffset = Vector2(0, 0)
var offsetDelta = Vector2(0, 0)

# ========================
# ==== CUSTOM METHODS ====
# ========================

func update_rotation(rotation_):
	baseOffset = OFFSET_FROM_PLAYER.rotated(rotation_)
	offset = baseOffset

func player_damaged(_health_, amt):
	if amt < 0:
		trauma = 0.3*pow(-amt, 0.5)

func shake():
	var shakeDirection = Vector2(0, 1).rotated(randf_range(-PI, PI))
	var x = trauma * maxOffset.x * shakeDirection.x
	var y = trauma * maxOffset.y * shakeDirection.y
	
	offset = baseOffset + Vector2(x, y)

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	baseOffset = OFFSET_FROM_PLAYER
	
	var playerNode = get_parent()
	playerNode.health_changed.connect(player_damaged)
	
	position_smoothing_enabled = true
	position_smoothing_speed = 3

	call_deferred("reset_smoothing")

func _process(delta):
	if trauma > 0 && delta > 0:
		trauma = max(trauma - delta*traumaDecay, 0)
		shake()
