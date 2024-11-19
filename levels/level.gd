extends Node2D

@onready var pauseMenu = $UI.get_node('UIManager').get_node('PauseMenu')
@export var enemyScene: PackedScene = preload("res://enemies/enemy.tscn")
@export var playerScene: PackedScene = preload("res://player/Player.tscn")
@export var playerCameraScene: PackedScene = preload("res://player/PlayerCamera.tscn")

@onready var UIManager = $UI/UIManager

var paused = false

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
	$Enemies.add_child(enemy)
	enemy.initialize(Vector2(0, -420))
	
	UIManager.initialize(player)
