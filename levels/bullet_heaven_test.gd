extends Node2D

var HUDScene = preload("res://ui/HUD.tscn")
var playerScene = preload("res://player/Player.tscn")
var inputManager = preload("res://utils/InputManager.gd")
var pickupManager = preload("res://pickups/pickups.gd")

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
	
	var pickupsNode = Node2D.new()
	pickupsNode.set_name('Pickups')
	pickupsNode.set_script(pickupManager)
	add_child(pickupsNode)
	
	var inputManagerNode = Node2D.new()
	inputManagerNode.set_name('InputManager')
	inputManagerNode.set_script(inputManager)
	add_child(inputManagerNode)


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
	
	var HUDNode = HUDScene.instantiate()
	add_child(HUDNode)
	$HUD/UIManager.initialize(player)
	
	resume()
