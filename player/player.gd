extends CharacterBody2D

signal damaged(health)
signal moved(pos: Vector2)
signal rotated(angle: float)

@export var bulletScene: PackedScene

@onready var levelNode = get_tree().get_root().get_node('Level')
@onready var bulletNode = get_tree().get_root().get_node("Level/PlayerBullets")
@onready var particlesNode = get_tree().get_root().get_node('Level/Particles')

var speed = 250
var health = 100
var rotationSpeed = 0.8
var invincible = false

# ========================
# ==== CUSTOM METHODS ====
# ========================

func initialize(startPosition: Vector2,):
	#levelNode = baseNode
	position = startPosition


func damage(amt):
	health -= amt
	damaged.emit(health)
	
	if health <= 0:
		print('died')
		queue_free()


func spawn_bullet():
	var bullet = bulletScene.instantiate()
	bulletNode.add_child(bullet)
	
	bullet.initialize(position, -global_transform.y)


func handle_mouse_input(event):
	if event is InputEventMouseMotion and !levelNode.paused:
		if event.relative.x > 0:
			self.rotate(0.02)
			rotated.emit(rotation)
		elif event.relative.x < 0:
			self.rotate(-0.02)
			rotated.emit(rotation)

# ========================
# ===== NODE METHODS ===== 
# ========================

func _ready():
	motion_mode = MOTION_MODE_FLOATING
	#levelNode = get_tree().get_root().get_node('Level')

func _process(delta):
	var playerMoved = false
	var playerRotated = false
	var movementVec = Vector2(0, 0)
	var speedMultiplier = 1;
	
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
	if Input.is_action_pressed('shift'):
		speedMultiplier = 2
	
	if playerMoved:
		var direction = movementVec.normalized()
		
		velocity = speed * direction * speedMultiplier
		move_and_slide()
		# position += delta * speed * direction * speedMultiplier
		moved.emit(position)
	
	if playerRotated and !levelNode.paused:
		rotated.emit(rotation)


func _input(event):
	handle_mouse_input(event)
	
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

func _on_hitbox_body_entered(body):
	if body.is_in_group("enemy_bullets"):
		var particles = body.particles.instantiate();
		
		var direction = -1 * body.linear_velocity.normalized()
		particles.initialize(body.position, direction)
		particlesNode.add_child(particles);
		particles.emitting=true;
		body.queue_free()
		
		if !invincible: damage(10)

func _on_bullet_spawn_timer_timeout():
	spawn_bullet()
