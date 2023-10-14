extends Area2D

var speed = 200

# ========================
# ===== NODE METHODS =====
# ========================

func _process(delta):
	if Input.is_action_pressed('player_left'):
		position.x -= speed * delta
	if Input.is_action_pressed('player_right'):
		position.x += speed * delta
	if Input.is_action_pressed('player_up'):
		position.y -= speed * delta
	if Input.is_action_pressed('player_down'):
		position.y += speed * delta

