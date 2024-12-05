extends CharacterBody2D

@export var particles: PackedScene
@export var creatureName = 'unknown'
@export var health = 50
@export var speed = 160
@export var pointValue = 1

@export var isAggressive = false
@export var aggressionRange = 400
@export var meleeInterval = 0.6
@export var contactDamage = 5

@export var bulletScene: PackedScene = preload('res://bullets/Bullet.tscn')
@export var canShoot = false
@export var isShootingTargeted = false
@export var bulletSpeed = 0
@export var bulletDamage = 10
@export var patternInterval = 1
@export var numBullets = 0
@export var shotsPerPattern = 0

@onready var mainNode = get_tree().get_root().get_node("Level")
@onready var bulletsNode = get_tree().get_root().get_node('Level/Enemies/EnemyBullets')


#var mainNode: Node
var playerNode: CharacterBody2D
var meleeBody: CharacterBody2D
var t = 0
var rng = RandomNumberGenerator.new()

# ========================
# ==== CUSTOM METHODS ====
# ========================

func initialize(startPosition: Vector2, player: CharacterBody2D):
	position = startPosition
	playerNode = player


func damage(amt):
	health -= amt
	$HitFlash.play('hit_flash')
	
	if health <= 0:
		mainNode.enemy_died(self)
		queue_free()


func spawn_undirected_bullets(
	delta: float, shotInterval: float, numBullets_: int, shotsPerPattern_: int, k=1, offset=0, alpha=1
):
	var frac = Math.modulo_float(t, shotInterval)
	var timeSinceLastShot = frac + delta
	
	var n_hist = floor(t/shotInterval) # number of shots that have already fired in the pattern
	var n = floor(timeSinceLastShot/shotInterval) # number of shots to perform
	
	if (n_hist > alpha * shotsPerPattern):
		return


	for i in range(n):
		for j in range(numBullets_):
			var bullet = bulletScene.instantiate()
			bulletsNode.add_child(bullet)
			
			bullet.damageAmt = bulletDamage
			bullet.speed = bulletSpeed
			
			var bulletDirection = Vector2(1.0, 0.0).rotated(
				2 * PI * pow(k, j) * ((n_hist/shotsPerPattern_) + (float(j)/numBullets) + offset)
			)
			var deltaPosition = bullet.speed * (timeSinceLastShot - i*shotInterval) * bulletDirection
			bullet.initialize(position + deltaPosition, bulletDirection)


func spawn_directed_bullets(delta):
	var timeSinceLastShot = t + delta
	
	if timeSinceLastShot > patternInterval:
		var bullet = bulletScene.instantiate()
		bulletsNode.add_child(bullet)
		
		bullet.damageAmt = bulletDamage
		bullet.speed = bulletSpeed
		
		var bulletDirection = (playerNode.position - position).normalized()
		var deltaPosition = bullet.speed * bulletDirection * (timeSinceLastShot - patternInterval)
		bullet.initialize(position + deltaPosition, bulletDirection)

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	$MeleeTimer.wait_time = meleeInterval


func _process(delta):
	if canShoot:
		if isShootingTargeted:
			spawn_directed_bullets(delta)
		else:
			spawn_undirected_bullets(
				delta, 0.15, numBullets, shotsPerPattern, -1, 0, 1
			)
	
	if playerNode && is_instance_valid(playerNode):
		var displacement = playerNode.position - position
		var distance = displacement.length()
		
		if distance < aggressionRange:
			isAggressive = true
		
		if isAggressive:
			velocity = speed * displacement.normalized()
			look_at(playerNode.position)
	
	move_and_slide()
	
	t += delta
	if (t > patternInterval):
		t = Math.modulo_float(t, patternInterval)


# ========================
# ====== RECIEVERS =======
# ========================

func _on_hitbox_body_entered(body: Node2D):
	# layer 3: PlayerBullets
	if body.get_collision_layer_value(3):
		body.hit()
		damage(body.damageAmt)
		isAggressive = true
	# layer 1: Player
	elif body.get_collision_layer_value(1):
		$MeleeTimer.start()
		meleeBody = body
		meleeBody.damage(contactDamage)


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group('player'):
		$MeleeTimer.stop()
		meleeBody = null


func _on_melee_timer_timeout() -> void:
	meleeBody.damage(contactDamage)


func _on_movement_timer_timeout() -> void:
	var direction = Vector2(0, 1).rotated(2*PI*rng.randf())
	look_at(position + direction)
	velocity = speed * direction
