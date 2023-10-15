extends Area2D

signal damaged(health)
var uiNode: Node
var healthbarNode: Node

var speed = 200
var health = 100

# ========================
# ==== CUSTOM METHODS ====
# ========================

func damage():
	health -= 10
	damaged.emit(health)
	
	if health <= 0:
		print('died')
		queue_free()

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	uiNode = get_tree().get_root().get_node("Level").get_node("UI")

func _process(delta):
	if Input.is_action_pressed('player_left'):
		position.x -= speed * delta
	if Input.is_action_pressed('player_right'):
		position.x += speed * delta
	if Input.is_action_pressed('player_up'):
		position.y -= speed * delta
	if Input.is_action_pressed('player_down'):
		position.y += speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemy_bullets"):
		damage()
		body.queue_free()
