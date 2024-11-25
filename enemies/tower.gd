extends Node2D

@export var bulletScene: PackedScene = preload('res://bullets/Bullet.tscn')
@export var health = 500

@onready var bulletsNode = get_tree().get_root().get_node('Level/Enemies/EnemyBullets')

var playerNode
var t = 0
var T = 4 # time when t resets back to 0

func update_healthbar_rotation(rotation_):
	$UI.rotation = rotation_

func damage(amt):
	health -= amt
	$UI/Healthbar.set_value(health)
	
	if health <= 0:
		queue_free()

func initialize(startPosition: Vector2, player: CharacterBody2D):
	position = startPosition
	playerNode = player
	playerNode.rotated.connect(update_healthbar_rotation)

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
			# TODO: perhaps keep the bullet scenes packed into
			# a lookup table accessible to the main node
			var bullet = bulletScene.instantiate()
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
	$UI/Healthbar.max_value = health
	$UI/Healthbar.set_value(health)
	
func _process(delta):
	spawn_bullets(delta, 0.15, 2, 32, -1, 0, 1)
	
	t += delta;
	if (t > T):
		t = Math.modulo_float(t, T)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_bullets"):
		damage(body.damage_amt)
		body.queue_free()
