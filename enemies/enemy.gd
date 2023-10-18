extends CharacterBody2D

@export var bulletScene: PackedScene = preload('res://bullets/Bullet.tscn')
var mainNode: Node
var bulletsNode: Node
var particlesNode: Node

var t = 0
var amp = 50.0 # amplitude
var anchorPosition: Vector2
var bulletsPerPattern = 70
var bulletInterval = 0.05
var T = bulletsPerPattern * bulletInterval # period

# ========================
# ==== CUSTOM METHODS ====
# ========================

func initialize(startPosition: Vector2):
	anchorPosition = startPosition
	position = startPosition

func spawn_bullets(t, delta):
	# ex: t: 0.14 => frac: 0.04, 
	# ex: t: 2.09 => frac: 0.09
	var frac = Math.modulo_float(t, bulletInterval)
	var timeSinceLastBullet = frac + delta
	
	# n_hist: the number of bullets that have already spawned in the cycle
	# n: the number of bullets that should be spawned in
	var n_hist = floor(t/bulletInterval)
	var n = floor(timeSinceLastBullet/bulletInterval)
	
	for i in range(n):
		var bullet = bulletScene.instantiate()
		bulletsNode.add_child(bullet)
		
		var bulletDirection = Vector2(1.0, 0.0).rotated(-PI*2*n_hist/bulletsPerPattern)
		var deltaPosition = bullet.speed * delta * bulletDirection
		bullet.initialize(position + deltaPosition, bulletDirection)

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	mainNode = get_tree().get_root().get_node('Level')
	bulletsNode = mainNode.get_node("Enemies").get_node("EnemyBullets")
	
func _process(delta):
	spawn_bullets(t, delta)
	
	t += delta;
	if (t > T):
		t = Math.modulo_float(t, T)
	
	#position = Vector2(anchorPosition.x + amp*sin(t * 2*PI/T), anchorPosition.y)
