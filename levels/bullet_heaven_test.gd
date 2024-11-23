extends Node2D

@export var enemyScene: PackedScene = preload("res://enemies/FollowEnemy.tscn")
@export var towerScene: PackedScene = preload("res://enemies/Tower.tscn")
@export var playerScene: PackedScene = preload("res://player/Player.tscn")
@export var playerCameraScene: PackedScene = preload("res://player/PlayerCamera.tscn")

@onready var UIManager = $UI/UIManager
@onready var pauseMenu = $UI/UIManager/PauseMenu

var paused = false
var t = 0
var rng = RandomNumberGenerator.new()
var spawn_interval = 5
var xp = 0

# ========================
# ==== CUSTOM METHODS ====
# ========================

func pause():
	paused = true
	Engine.time_scale = 0
	pauseMenu.show()

func resume():
	paused = false
	Engine.time_scale = 1
	pauseMenu.hide()

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

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	resume()
	
	# instantiate player and enemies
	var player = playerScene.instantiate()
	add_child(player)
	player.initialize(Vector2(-500, 400))
	
	var enemy = enemyScene.instantiate()
	enemy.initialize(Vector2(200, 400), player)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
	$Enemies.add_child(enemy)
	
	#var tower = towerScene.instantiate()
	#tower.initialize(Vector2(-100, 300), player)
	#$Enemies.add_child(tower)
	
	UIManager.initialize(player)
	
	# connect signals
	pauseMenu.resume.connect(resume)
	pauseMenu.quit.connect(quit)

func _process(delta):
	t += delta
	
	if fmod(t, spawn_interval) - delta < 0:
		var theta = 2*PI*rng.randf()
		var displacement = 500 * Vector2(cos(theta), sin(theta))
		var spawn_pos = $Player.position + displacement
		
		#var enemy = enemyScene.instantiate()
		#enemy.initialize(spawn_pos, $Player)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
		#$Enemies.add_child(enemy)
