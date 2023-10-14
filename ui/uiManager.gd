extends Control

var playerNode: Node

func update_healthbar(health):
	$Healthbar.set_value(health)

func _ready():
	playerNode = get_tree().get_root().get_node("Level").get_node("Player")
	playerNode.damaged.connect(update_healthbar);
