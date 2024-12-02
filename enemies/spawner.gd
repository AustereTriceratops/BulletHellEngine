extends Node2D

@export var enemyScene: PackedScene

@onready var playerNode = get_tree().get_root().get_node('Level/Player')
@onready var enemiesNode = get_tree().get_root().get_node('Level/Enemies')

# ========================
# ====== RECIEVERS =======
# ========================

func _on_spawn_timer_timeout() -> void:
	var enemy = enemyScene.instantiate()
	enemy.initialize(position, playerNode)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
	enemiesNode.add_child(enemy)
