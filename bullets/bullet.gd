extends RigidBody2D

@export var particles: PackedScene
@export var damageAmt = 10
@export var speed = 400

# ========================
# ==== CUSTOM METHODS ====
# ========================

func initialize(position_: Vector2, direction: Vector2):
	position = position_
	set_linear_velocity(speed * direction)

# ========================
# ====== RECIEVERS =======
# ========================

func _on_despawn_timer_timeout():
	queue_free()
