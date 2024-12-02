extends Node2D

@export var enemyScene: PackedScene

@onready var mainNode = get_tree().get_root().get_node("Level")
var playerNode: CharacterBody2D
var enemiesNode : Node
var rng = RandomNumberGenerator.new()

# ========================
# ==== CUSTOM METHODS ====
# ========================

func _ready():
	mainNode.ready.connect(_on_main_ready)

# ========================
# ====== RECIEVERS =======
# ========================

func _on_main_ready():
	playerNode = mainNode.get_node("Player")
	enemiesNode = mainNode.get_node("Enemies")
	

func _on_spawn_timer_timeout() -> void:
	var enemy = enemyScene.instantiate()
	var theta = 2 * PI * rng.randf()
	var displacement = 20*Vector2(cos(theta), sin(theta))
	enemy.initialize(position + displacement, playerNode)
	enemiesNode.add_child(enemy)
