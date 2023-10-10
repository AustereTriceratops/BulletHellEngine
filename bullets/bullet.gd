extends RigidBody2D

var speed = 20;

# ========================
# ==== CUSTOM METHODS ====
# ========================

func initialize(startPosition: Vector2):
	position = startPosition
	print(position)

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _on_timer_timeout():
	queue_free()
