extends RigidBody2D

@export var particles: PackedScene

var damage_amt = 1
var speed = 400;

# ========================
# ==== CUSTOM METHODS ====
# ========================

func initialize(position_: Vector2, direction: Vector2):
	position = position_
	set_linear_velocity(speed * direction)

# ========================
# ===== NODE METHODS =====
# ========================

func _on_despawn_timer_timeout():
	queue_free()
