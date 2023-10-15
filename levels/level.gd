extends Node2D

@export var enemyScene: PackedScene = preload("res://enemies/enemy.tscn")

# ========================
# ==== CUSTOM METHODS ====
# ========================



# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	var enemy = enemyScene.instantiate()
	$Enemies.add_child(enemy)
	enemy.initialize(Vector2(500, 200))
