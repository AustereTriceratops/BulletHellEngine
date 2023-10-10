extends CharacterBody2D

@export var bulletScene: PackedScene = preload('res://bullets/Bullet.tscn')
var mainNode: Node
var bulletsNode: Node
var particlesNode: Node

var t = 0
var T = 10.0 # period
var amp = 50.0 # amplitude
var anchorPosition: Vector2

# ========================
# ==== CUSTOM METHODS ====
# ========================

func initialize(startPosition: Vector2):
	anchorPosition = startPosition
	position = startPosition
	
func spawn_bullet():
	var bullet = bulletScene.instantiate()
	bulletsNode.add_child(bullet)
	bullet.initialize(position)

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	mainNode = get_tree().get_root().get_node('Level')
	bulletsNode = mainNode.get_node("Enemies").get_node("EnemyBullets")
	#particlesNode = mainNode.get_node("Particles")
	
func _process(delta):
	t += delta;
	if (t > T):
		t = t - T*floor(t/T);
		
	position = Vector2(anchorPosition.x + amp*sin(t * 2*PI/T), anchorPosition.y)

func _on_timer_timeout():
	spawn_bullet()
