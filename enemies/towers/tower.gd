extends Node2D

@export var bulletScene: PackedScene = preload('res://bullets/Bullet.tscn')
@export var playerBulletScene: PackedScene = preload('res://bullets/PlayerBullet.tscn')
@export var startingHealth = 500
@export var bulletSpeed = 400

@onready var mainNode = get_tree().get_root().get_node("Level")
var bulletsNode

var playerNode: CharacterBody2D
var health: int
var t = 0
var T = 4 # time when t resets back to 0
var allied = false

func update_healthbar_rotation(rotation_):
	$UI.rotation = rotation_

func damage(amt):
	health -= amt
	
	if health <= 0:
		health = startingHealth
		allied = !allied
		
	$UI/Healthbar.set_value(health)

func spawn_bullets(
	delta: float, shotInterval: float, numBullets: int, shotsPerPattern: int, k=1, offset=0, alpha=1
):
	var frac = Math.modulo_float(t, shotInterval)
	var timeSinceLastShot = frac + delta
	
	var n_hist = floor(t/shotInterval) # number of shots that have already fired in the pattern
	var n = floor(timeSinceLastShot/shotInterval) # number of shots to perform
	
	if (n_hist > alpha * shotsPerPattern):
		return
	
	for i in range(n):
		for j in range(numBullets):
			var bullet
			
			if allied:
				bullet = playerBulletScene.instantiate()
			else:
				bullet = bulletScene.instantiate()
	
			bullet.speed = bulletSpeed
			bulletsNode.add_child(bullet)
			
			var bulletDirection = Vector2(1.0, 0.0).rotated(
				pow(k, j) * PI * 2 * ((n_hist/shotsPerPattern) + (float(j)/numBullets) + offset)
			)
			var deltaPosition = bullet.speed * (timeSinceLastShot - i*shotInterval) * bulletDirection
			bullet.initialize(position + deltaPosition, bulletDirection)

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	mainNode.ready.connect(_on_main_ready)
	
	health = startingHealth
	$UI/Healthbar.max_value = startingHealth
	$UI/Healthbar.set_value(startingHealth)
	
func _process(delta):
	if is_instance_valid(bulletsNode):
		spawn_bullets(delta, 0.15, 2, 32, -1, 0, 1)
	
	t += delta;
	if (t > T):
		t = Math.modulo_float(t, T)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_bullets") && !allied:
		damage(body.damageAmt)
		body.queue_free()

# ========================
# ====== RECIEVERS =======
# ========================

func _on_main_ready():
	bulletsNode = mainNode.get_node("Enemies/EnemyBullets")
	playerNode = mainNode.get_node("Player")
	playerNode.rotated.connect(update_healthbar_rotation)
