extends Node2D

@onready var pauseMenu = $UI.get_node('UIManager').get_node('PauseMenu')
@export var enemyScene: PackedScene = preload("res://enemies/enemy.tscn")

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
	get_tree().quit()

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	pauseMenu.resume.connect(resume)
	pauseMenu.quit.connect(quit)
	var enemy = enemyScene.instantiate()
	$Enemies.add_child(enemy)
	enemy.initialize(Vector2(800, 200))
