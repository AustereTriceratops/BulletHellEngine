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

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	resume()
	
	pauseMenu.resume.connect(resume)
	pauseMenu.quit.connect(quit)
	
	var player = playerScene.instantiate()
	add_child(player)
	player.initialize(Vector2(-300, 700))
	
	var enemy = enemyScene.instantiate()
	enemy.initialize(Vector2(0, -420), player)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
	$Enemies.add_child(enemy)
	
	var tower = towerScene.instantiate()
	tower.initialize(Vector2(-100, 300), player)
	$Enemies.add_child(tower)
	
	var playerCamera = playerCameraScene.instantiate()
	add_child(playerCamera)
	playerCamera.initialize(player)
	
	UIManager.initialize(player)

func _process(delta):
	t += delta
	
	if fmod(t, spawn_interval) - delta < 0:
		var theta = 2*PI*rng.randf()
		var displacement = 500 * Vector2(cos(theta), sin(theta))
		var spawn_pos = $Player.position + displacement
		
		var enemy = enemyScene.instantiate()
		enemy.initialize(spawn_pos, $Player)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
		$Enemies.add_child(enemy)
