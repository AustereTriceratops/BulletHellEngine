extends CharacterBody2D

@export var bulletScene: PackedScene = preload('res://bullets/Bullet.tscn')
@onready var bulletsNode = get_tree().get_root().get_node('Level/Enemies/EnemyBullets')
var particlesNode: Node

var t = 0
var T = 2.4 # time when t resets back to 0
var amp = 50.0 # amplitude
var anchorPosition: Vector2
var health = 10

# ========================
# ==== CUSTOM METHODS ====
# ========================

func damage(amt):
	health -= amt
	
	if health <= 0:
		queue_free()

func initialize(startPosition: Vector2):
	anchorPosition = startPosition
	position = startPosition

func spawn_bullets(
	delta: float, shotInterval: float, numBullets: int, shotsPerPattern: int, k=1, offset=0, alpha=1
):
	# ex: t: 0.14 => frac: 0.04, 
	# ex: t: 2.09 => frac: 0.09
	var frac = Math.modulo_float(t, shotInterval)
	var timeSinceLastShot = frac + delta
	
	var n_hist = floor(t/shotInterval) # number of shots that have already fired in the pattern
	var n = floor(timeSinceLastShot/shotInterval) # number of shots to perform
	
	if (n_hist > alpha * shotsPerPattern):
		return
	
	for i in range(n):
		for j in range(numBullets):
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
	
func _process(delta):
	spawn_bullets(delta, 0.1, 6, 24, -1, 0, 1)
	spawn_bullets(delta, 0.04, 2, 32, 1, 0.2, 0.6)
	
	t += delta;
	if (t > T):
		t = Math.modulo_float(t, T)
	
	#position = Vector2(anchorPosition.x + amp*sin(t * 2*PI/T), anchorPosition.y)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player_bullets"):
		damage(body.damageAmt)
		body.hit()
