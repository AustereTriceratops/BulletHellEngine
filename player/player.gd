extends Area2D

signal damaged(health)
signal moved(position: Vector2)
signal rotated(rotation: float)


var particlesNode: Node
var cameraNode: Camera2D

var speed = 200
var health = 100
var rotationSpeed = 0.5

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
	particlesNode = get_tree().get_root().get_node('Level').get_node('Particles')

func _process(delta):
	var playerMoved = false
	var playerRotated = false
	var movementVec = Vector2(0, 0)
	
	if Input.is_action_pressed('player_left'):
		movementVec -= global_transform.x
		playerMoved = true
	if Input.is_action_pressed('player_right'):
		movementVec += global_transform.x
		playerMoved = true
	if Input.is_action_pressed('player_up'):
		movementVec -= global_transform.y
		playerMoved = true
	if Input.is_action_pressed('player_down'):
		movementVec += global_transform.y
		playerMoved = true
	if Input.is_action_pressed('look_right'):
		rotate(rotationSpeed * delta)
		playerRotated = true
	if Input.is_action_pressed('look_left'):
		rotate(-rotationSpeed * delta)
		playerRotated = true
	
	if playerMoved:
		var direction = movementVec.normalized()
		position += delta * speed * direction
		moved.emit(position)
	
	if playerRotated:
		rotated.emit(rotation)

func _input(_event):
	if Input.is_action_just_released('player_left') || Input.is_action_just_released('player_right'):
		var tween = create_tween()
		tween.tween_property(
			$Sprite, 'rotation', 0, 0.3
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
	if Input.is_action_just_pressed('player_left'):
		if Input.is_action_pressed('player_right'):
			# ignore_right = true #this may be a better approach
			Input.action_release('player_right')
			
		var tween = create_tween()
		tween.tween_property(
			$Sprite, 'rotation', -0.2, 0.3
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
	if Input.is_action_just_pressed('player_right'):
		if Input.is_action_pressed('player_left'):
			Input.action_release('player_left')
			
		var tween = create_tween()
		tween.tween_property(
			$Sprite, 'rotation', 0.2, 0.3
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _on_body_entered(body):
	if body.is_in_group("enemy_bullets"):
		var particles = body.particles.instantiate();
		
		var direction = -1 * body.linear_velocity.normalized()
		particles.initialize(body.position, direction)
		particlesNode.add_child(particles);
		particles.emitting=true;
		body.queue_free()
		
		damage()
