extends Node2D

@export var HUDScene : PackedScene = preload("res://ui/HUD.tscn")
@export var enemyScene: PackedScene = preload("res://enemies/FollowEnemy.tscn")
@export var enemyScene2: PackedScene = preload("res://enemies/FollowEnemy2.tscn")
@export var towerScene: PackedScene = preload("res://enemies/towers/Tower.tscn")
@export var playerScene: PackedScene = preload("res://player/Player.tscn")
@export var playerCameraScene: PackedScene = preload("res://player/PlayerCamera.tscn")

var paused = false
var t = 0
var rng = RandomNumberGenerator.new()
var spawn_interval = 4
var xp = 0

# ========================
# ==== CUSTOM METHODS ====
# ========================

func setup():
	var particlesNode = Node2D.new()
	particlesNode.set_name('Particles')
	add_child(particlesNode)
	
	var playerBulletsNode = Node2D.new()
	playerBulletsNode.set_name('PlayerBullets')
	add_child(playerBulletsNode)
	
	var enemiesNode = Node2D.new()
	enemiesNode.set_name('Enemies')
	add_child(enemiesNode)
	
	var enemyBulletsNode = Node2D.new()
	enemyBulletsNode.set_name('EnemyBullets')
	enemiesNode.add_child(enemyBulletsNode)


func pause():
	paused = true
	Engine.time_scale = 0
	$HUD/UIManager/PauseMenu.show()

func resume():
	paused = false
	Engine.time_scale = 1
	$HUD/UIManager/PauseMenu.hide()

func options():
	pass

func quit():
	get_tree().change_scene_to_file('res://ui/StartMenu.tscn')


func player_died():
	get_tree().call_deferred('change_scene_to_file', 'res://ui/GameOverMenu.tscn')

func enemy_died(enemyNode):
	var particles = enemyNode.particles.instantiate();
	particles.initialize(enemyNode.position)
	$Particles.add_child(particles)
	particles.emitting=true
	
	xp += enemyNode.pointValue
	$HUD/UIManager/XpLabel.text = str(xp)
	
	$Pickups.spawn_pickup(enemyNode.position)

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	setup()
	
	# instantiate player and enemies
	var player = playerScene.instantiate()
	add_child(player)
	player.initialize(Vector2(0, 300))
	
	var enemy = enemyScene2.instantiate()
	enemy.initialize(Vector2(200, 400), player)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
	$Enemies.add_child(enemy)
	
	var tower = towerScene.instantiate()
	tower.initialize(Vector2(-100, -900), player)
	$Enemies.add_child(tower)
	
	var HUDNode = HUDScene.instantiate()
	add_child(HUDNode)
	$HUD/UIManager.initialize(player)
	
	resume()

func _process(delta):
	pass
	#t += delta
	#
	#if fmod(t, spawn_interval) - delta < 0:
		#var theta = 2*PI*rng.randf()
		#var dist = rng.randf_range(300, 500)
		#var displacement = dist * Vector2(cos(theta), sin(theta))
		#var spawn_pos = $Player.position + displacement
		#
		#var enemy = enemyScene.instantiate()
		#enemy.initialize(spawn_pos, $Player)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
		#$Enemies.add_child(enemy)
