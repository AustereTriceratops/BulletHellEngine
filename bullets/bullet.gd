extends RigidBody2D

@export var particles: PackedScene
@export var damageAmt = 10
@export var speed = 400

var maxHits = 1
var hits = 0

# ========================
# ==== CUSTOM METHODS ====
# ========================

func initialize(position_: Vector2, direction: Vector2):
	position = position_
	set_linear_velocity(speed * direction)
	
func hit():
	hits += 1
	if hits >= maxHits:
		queue_free()

# ========================
# ====== RECIEVERS =======
# ========================

func _on_despawn_timer_timeout():
	queue_free()
