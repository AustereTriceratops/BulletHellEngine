extends Area2D

signal damaged(health)
signal moved(position: Vector2)

var speed = 200
var health = 100

# ========================
# ==== CUSTOM METHODS ====
# ========================

func damage():
	health -= 10
	damaged.emit(health)
	
	if health <= 0:
		print('died')
		queue_free()

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	pass

func _process(delta):
	var playerMoved = false
	var movementVec = Vector2(0, 0)
	
	if Input.is_action_pressed('player_left'):
		movementVec += Vector2(-1.0, 0.0)
		playerMoved = true
	if Input.is_action_pressed('player_right'):
		movementVec += Vector2(1.0, 0.0)
		playerMoved = true
	if Input.is_action_pressed('player_up'):
		movementVec += Vector2(0.0, -1.0)
		playerMoved = true
	if Input.is_action_pressed('player_down'):
		movementVec += Vector2(0.0, 1.0)
		playerMoved = true
	
	if playerMoved:
		var direction = movementVec.normalized()
		position += delta * speed * direction
		moved.emit(position)

func _input(event):
	if Input.is_action_just_released('player_left') || Input.is_action_just_released('player_right'):
		var tween = create_tween()
		tween.tween_property(
			self, 'rotation', 0, 0.3
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
	if Input.is_action_just_pressed('player_left'):
		if Input.is_action_pressed('player_right'):
			# ignore_right = true #this may be a better approach
			Input.action_release('player_right')
			
		var tween = create_tween()
		tween.tween_property(
			self, 'rotation', -0.2, 0.3
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
	if Input.is_action_just_pressed('player_right'):
		if Input.is_action_pressed('player_left'):
			Input.action_release('player_left')
			
		var tween = create_tween()
		tween.tween_property(
			self, 'rotation', 0.2, 0.3
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _on_body_entered(body):
	if body.is_in_group("enemy_bullets"):
		damage()
		body.queue_free()
