extends RigidBody2D

@export var particles: PackedScene

var speed = 400;

# ========================
# ==== CUSTOM METHODS ====
# ========================

func initialize(startPosition: Vector2, direction: Vector2):
	position = startPosition
	set_linear_velocity(speed * direction)

# ========================
# ===== NODE METHODS =====
# ========================

func _on_despawn_timer_timeout():
	queue_free()
