extends CharacterBody2D

signal health_changed(health, amt)
signal rotated(rotation)
signal moved(pos: Vector2)

@export var bulletScene: PackedScene
var bulletDamage = 10
var bulletSpeed = 600
var speed = 400
var health = 100
var rotationSpeed = 0.03
var invincible = false
var hasLaser = false
var bulletInterval = 0.2
var recoveryTime = 0.4

@onready var mainNode = get_tree().get_root().get_node('Level')
@onready var bulletsNode = get_tree().get_root().get_node("Level/PlayerBullets")
@onready var particlesNode = get_tree().get_root().get_node('Level/Particles')

var RAY_LENGTH = 1000
var t = 0

# ========================
# ==== CUSTOM METHODS ====
# ========================

func initialize(startPosition: Vector2):
	position = startPosition


func damage(amt):
	if $RecoveryTimer.time_left == 0 && !invincible:
		$RecoveryTimer.start()
		$HitFlash.play('hit_flash')
		
		health -= amt
		health_changed.emit(health, -amt)
	
		if health <= 0:
			mainNode.player_died()
			queue_free()

### philosophy: all of a bullet's properties are conferred by the
### game object which spawns them (e.g. speed, damage, status effects)
func spawn_bullet():
	var bullet = bulletScene.instantiate()
	bulletsNode.add_child(bullet)
	
	bullet.damageAmt = bulletDamage
	bullet.speed = bulletSpeed
	bullet.initialize(position, -global_transform.y)


func handle_mouse_input(event):
	if event is InputEventMouseMotion and !mainNode.paused:
		if event.relative.x > 0:
			self.rotate(rotationSpeed)
			$PlayerCamera.update_rotation(rotation)
			rotated.emit(rotation)
		elif event.relative.x < 0:
			self.rotate(-rotationSpeed)
			$PlayerCamera.update_rotation(rotation)
			rotated.emit(rotation)

# ========================
# ===== NODE METHODS ===== 
# ========================

func _ready():
	motion_mode = MOTION_MODE_FLOATING
	
	$PlayerCamera.update_rotation(rotation)
	$BulletSpawnTimer.set_wait_time(bulletInterval)
	$RecoveryTimer.set_wait_time(recoveryTime)
	
	if hasLaser:
		$LaserSprite.visible = true

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
		moved.emit(position)
	
	if playerRotated and !mainNode.paused:
		$PlayerCamera.update_rotation(rotation)
		rotated.emit(rotation)
	
	t += delta

func _physics_process(delta):
	if hasLaser && fmod(t + delta, 0.2) - delta < 0:
		if $Ray.is_colliding():
			var body = $Ray.get_collider()
			
			if body:
				body.get_parent().damage(1)

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


# ========================
# ====== RECIEVERS ======= 
# ========================


func _on_hitbox_body_entered(body):
	if body.is_in_group("enemy_bullets"):
		damage(body.damageAmt)
		
		# spawn particles
		var particles = body.particles.instantiate();
		particlesNode.add_child(particles);
		
		var direction = -1 * body.linear_velocity.normalized()
		particles.initialize(body.position, direction)
		particles.emitting=true;
		
		# finally, remove the bullet that hit the player from the game
		body.queue_free()


	elif body.is_in_group('pickups'):
		health += 5
		health_changed.emit(health, 5)
		body.queue_free()

func _on_bullet_spawn_timer_timeout():
	spawn_bullet()
