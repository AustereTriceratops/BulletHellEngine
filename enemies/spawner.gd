extends Node2D

@export var enemyScene: PackedScene
@export var minRange = 100
@export var maxRange = 1000

@onready var mainNode = get_tree().get_root().get_node("Level")
var playerNode: CharacterBody2D
var enemiesNode : Node
var rng = RandomNumberGenerator.new()

# ========================
# ==== CUSTOM METHODS ====
# ========================

func _ready():
	mainNode.ready.connect(_on_main_ready)
	
	
func _process(_delta: float) -> void:
	var distanceToPlayer = (playerNode.position - position).length()
	
	if distanceToPlayer < minRange:
		if !$SpawnTimer.paused:
			$SpawnTimer.paused = true
	elif distanceToPlayer > maxRange:
		if !$SpawnTimer.paused:
			$SpawnTimer.paused = true
	else:
		if $SpawnTimer.paused:
			$SpawnTimer.paused = false

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
